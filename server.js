const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Use the correct SRV connection string from MongoDB Atlas
const MONGODB_URI = "mongodb+srv://kibu_app:KibuVote2024@cluster0.ggyc252.mongodb.net/fitness_tracker?retryWrites=true&w=majority&appName=Cluster0";

console.log("Attempting to connect to MongoDB...");

const workoutSchema = new mongoose.Schema({
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

app.get('/', (req, res) => {
  res.json({ 
    message: 'Fitness Tracker API is running!',
    endpoints: {
      health: '/health',
      workouts: '/workouts',
      create: 'POST /workouts',
      update: 'PUT /workouts/:id',
      delete: 'DELETE /workouts/:id'
    }
  });
});

app.get("/health", (req, res) => {
  res.json({ status: "ok", message: "Fitness Tracker API is running" });
});

app.get("/workouts", async (req, res) => {
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
    const workouts = await Workout.find().sort({ date: -1 }).maxTimeMS(30000);
    res.json(workouts);
  } catch (error) {
    res.status(500).json({ message: "Failed to fetch workouts", error: error.message });
  }
});

app.post("/workouts", async (req, res) => {
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
    const workout = new Workout(req.body);
    await workout.save();
    res.status(201).json(workout);
  } catch (error) {
    res.status(400).json({ message: "Failed to create workout", error: error.message });
  }
});

app.put("/workouts/:id", async (req, res) => {
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
    const workout = await Workout.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!workout) {
      return res.status(404).json({ message: "Workout not found" });
    }
    res.json(workout);
  } catch (error) {
    res.status(400).json({ message: "Failed to update workout", error: error.message });
  }
});

app.delete("/workouts/:id", async (req, res) => {
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
    const workout = await Workout.findByIdAndDelete(req.params.id);
    if (!workout) {
      return res.status(404).json({ message: "Workout not found" });
    }
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