import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/api_service.dart';

class WorkoutProvider extends ChangeNotifier {
  List<Workout> _workouts = [];
  bool _isLoading = false;

  List<Workout> get workouts => _workouts;
  bool get isLoading => _isLoading;

  // ===== STATISTICS GETTERS =====
  
  // Total number of workouts
  int get totalWorkouts => _workouts.length;
  
  // Total calories burned
  int get totalCalories {
    return _workouts.fold(0, (sum, workout) => sum + workout.calories);
  }
  
  // Average duration
  double get averageDuration {
    if (_workouts.isEmpty) return 0;
    int totalDuration = _workouts.fold(0, (sum, workout) => sum + workout.duration);
    return totalDuration / _workouts.length;
  }
  
  // Average calories per workout
  double get averageCalories {
    if (_workouts.isEmpty) return 0;
    return totalCalories / _workouts.length;
  }

  // ===== API METHODS =====

  // Load workouts from API
  Future<void> loadWorkouts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _workouts = await ApiService.getWorkouts();
    } catch (e) {
      print('Error loading workouts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add workout to API
  Future<void> addWorkout(Workout workout) async {
    try {
      final newWorkout = await ApiService.addWorkout(workout);
      _workouts.add(newWorkout);
      notifyListeners();
    } catch (e) {
      print('Error adding workout: $e');
      rethrow;
    }
  }

  // Update workout
  Future<void> updateWorkout(String id, Workout workout) async {
    try {
      final updatedWorkout = await ApiService.updateWorkout(id, workout);
      final index = _workouts.indexWhere((w) => w.id == id);
      if (index != -1) {
        _workouts[index] = updatedWorkout;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating workout: $e');
      rethrow;
    }
  }

  // Delete workout (called 'removeWorkout' for your UI)
  Future<void> removeWorkout(String id) async {
    try {
      await ApiService.deleteWorkout(id);
      _workouts.removeWhere((w) => w.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting workout: $e');
      rethrow;
    }
  }

  // Alternative: Same as removeWorkout (for compatibility)
  Future<void> deleteWorkout(String id) async {
    await removeWorkout(id);
  }
}