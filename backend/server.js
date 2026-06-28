const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Use environment variable or fallback to hardcoded
const MONGODB_URI = process.env.MONGODB_URI || "mongodb+srv://kibu_app:KibuVote2024@cluster0.ggyc252.mongodb.net/fitness_tracker?retryWrites=true&w=majority";

const workoutSchema = new mongoose.Schema({
  name: { type: String, required: true },
  duration: { type: Number, required: true },
  calories: { type: Number, required: true },
  date: { type: Date, default: Date.now }
});

const Workout = mongoose.model("Workout", workoutSchema);

app.get("/health", (req, res) => {
  res.json({ status: "ok", message: "Fitness Tracker API is running" });
});

app.get("/workouts", async (req, res) => {
  try {
    const workouts = await Workout.find().sort({ date: -1 });
    res.json(workouts);
  } catch (error) {
    res.status(500).json({ message: "Failed to fetch workouts", error: error.message });
  }
});

app.post("/workouts", async (req, res) => {
  try {
    const workout = new Workout(req.body);
    await workout.save();
    res.status(201).json(workout);
  } catch (error) {
    res.status(400).json({ message: "Failed to create workout", error: error.message });
  }
});

app.put("/workouts/:id", async (req, res) => {
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

// Start server only if MongoDB connects
async function startServer() {
  try {
    await mongoose.connect(MONGODB_URI);
    console.log("MongoDB connected successfully");
    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  } catch (error) {
    console.error("Failed to connect to MongoDB:", error.message);
    console.log("Using connection string:", MONGODB_URI);
    process.exit(1);
  }
}

startServer();