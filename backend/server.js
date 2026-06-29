const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

app.use(cors());
app.use(express.json());
app.use((req, res, next) => {
  console.log(`${req.method} ${req.path}`);
  next();
});

// MongoDB Connection
const MONGODB_URI = process.env.MONGODB_URI || "mongodb+srv://kibu_app:KibuVote2024@cluster0.ggyc252.mongodb.net/fitness_tracker?retryWrites=true&w=majority&appName=Cluster0";

console.log("Attempting to connect to MongoDB...");

// ===== USER SCHEMA =====
const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  fullName: { type: String, required: true },
  createdAt: { type: Date, default: Date.now }
});

const User = mongoose.model('User', userSchema);

// ===== WORKOUT SCHEMA (with userId) =====
const workoutSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  name: { type: String, required: true },
  duration: { type: Number, required: true },
  calories: { type: Number, required: true },
  date: { type: Date, default: Date.now }
});

const Workout = mongoose.model("Workout", workoutSchema);

let isConnected = false;

async function connectToDatabase() {
  if (isConnected) {
    console.log("Already connected to MongoDB");
    return;
  }
  
  try {
    console.log("Connecting to MongoDB...");
    await mongoose.connect(MONGODB_URI, {
      serverSelectionTimeoutMS: 60000,
      socketTimeoutMS: 60000,
      connectTimeoutMS: 60000,
      maxPoolSize: 1,
      minPoolSize: 1,
      family: 4
    });
    isConnected = true;
    console.log("MongoDB connected successfully");
  } catch (error) {
    console.error("MongoDB connection error:", error.message);
    console.error("Full error:", error);
  }
}

// Connect immediately
connectToDatabase();

// ===== AUTHENTICATION MIDDLEWARE =====
function authenticateToken(req, res, next) {
  const authHeader = req.headers.authorization;
  const token = authHeader && authHeader.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: 'Unauthorized - No token provided' });
  }
  
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.userId = decoded.userId;
    next();
  } catch (error) {
    return res.status(403).json({ error: 'Invalid or expired token' });
  }
}

// ===== AUTH ROUTES =====

// Register
app.post('/api/register', async (req, res) => {
  try {
    const { email, password, fullName } = req.body;
    
    if (!email || !password || !fullName) {
      return res.status(400).json({ error: 'All fields are required' });
    }
    
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ error: 'Email already registered' });
    }
    
    const hashedPassword = await bcrypt.hash(password, 10);
    
    const user = new User({
      email,
      password: hashedPassword,
      fullName
    });
    
    await user.save();
    
    const token = jwt.sign({ userId: user._id }, JWT_SECRET, { expiresIn: '7d' });
    
    res.status(201).json({
      token,
      profile: {
        id: user._id,
        email: user.email,
        fullName: user.fullName
      }
    });
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({ error: 'Registration failed' });
  }
});

// Login
app.post('/api/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required' });
    }
    
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }
    
    const valid = await bcrypt.compare(password, user.password);
    if (!valid) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }
    
    const token = jwt.sign({ userId: user._id }, JWT_SECRET, { expiresIn: '7d' });
    
    res.json({
      token,
      profile: {
        id: user._id,
        email: user.email,
        fullName: user.fullName
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Login failed' });
  }
});

// Get user profile (protected)
app.get('/api/profile', authenticateToken, async (req, res) => {
  try {
    const user = await User.findById(req.userId).select('-password');
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    res.json({
      id: user._id,
      email: user.email,
      fullName: user.fullName
    });
  } catch (error) {
    console.error('Profile error:', error);
    res.status(500).json({ error: 'Failed to get profile' });
  }
});

// ===== PUBLIC ROUTES =====

app.get('/', (req, res) => {
  res.json({ 
    message: 'Fitness Tracker API is running!',
    endpoints: {
      health: '/health',
      workouts: '/workouts',
      create: 'POST /workouts',
      update: 'PUT /workouts/:id',
      delete: 'DELETE /workouts/:id',
      register: 'POST /api/register',
      login: 'POST /api/login',
      profile: 'GET /api/profile'
    }
  });
});

app.get("/health", (req, res) => {
  res.json({ status: "ok", message: "Fitness Tracker API is running" });
});

// ===== PROTECTED WORKOUT ROUTES =====

// GET workouts - only return user's workouts
app.get("/workouts", authenticateToken, async (req, res) => {
  if (mongoose.connection.readyState !== 1) {
    try {
      await connectToDatabase();
    } catch (error) {
      return res.status(503).json({ 
        message: "Database connection is not ready", 
        error: error.message 
      });
    }
  }
  
  try {
    const workouts = await Workout.find({ userId: req.userId }).sort({ date: -1 });
    res.json(workouts);
  } catch (error) {
    res.status(500).json({ message: "Failed to fetch workouts", error: error.message });
  }
});

// POST workout - add with userId
app.post("/workouts", authenticateToken, async (req, res) => {
  if (mongoose.connection.readyState !== 1) {
    try {
      await connectToDatabase();
    } catch (error) {
      return res.status(503).json({ 
        message: "Database connection is not ready", 
        error: error.message 
      });
    }
  }
  
  try {
    const workout = new Workout({
      ...req.body,
      userId: req.userId
    });
    await workout.save();
    res.status(201).json(workout);
  } catch (error) {
    res.status(400).json({ message: "Failed to create workout", error: error.message });
  }
});

// PUT workout - ensure user owns it
app.put("/workouts/:id", authenticateToken, async (req, res) => {
  if (mongoose.connection.readyState !== 1) {
    try {
      await connectToDatabase();
    } catch (error) {
      return res.status(503).json({ 
        message: "Database connection is not ready", 
        error: error.message 
      });
    }
  }
  
  try {
    const workout = await Workout.findOne({ _id: req.params.id, userId: req.userId });
    if (!workout) {
      return res.status(404).json({ message: "Workout not found" });
    }
    
    const updatedWorkout = await Workout.findByIdAndUpdate(
      req.params.id, 
      req.body, 
      { new: true }
    );
    res.json(updatedWorkout);
  } catch (error) {
    res.status(400).json({ message: "Failed to update workout", error: error.message });
  }
});

// DELETE workout - ensure user owns it
app.delete("/workouts/:id", authenticateToken, async (req, res) => {
  if (mongoose.connection.readyState !== 1) {
    try {
      await connectToDatabase();
    } catch (error) {
      return res.status(503).json({ 
        message: "Database connection is not ready", 
        error: error.message 
      });
    }
  }
  
  try {
    const workout = await Workout.findOne({ _id: req.params.id, userId: req.userId });
    if (!workout) {
      return res.status(404).json({ message: "Workout not found" });
    }
    
    await Workout.findByIdAndDelete(req.params.id);
    res.json({ message: "Workout deleted", id: req.params.id });
  } catch (error) {
    res.status(400).json({ message: "Failed to delete workout", error: error.message });
  }
});

// For local development
if (require.main === module) {
  connectToDatabase().then(() => {
    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  });
}

// Export for Vercel
module.exports = app;