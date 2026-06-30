import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/api_service.dart';

class WorkoutProvider extends ChangeNotifier {
  List<Workout> _workouts = [];
  bool _isLoading = false;

  List<Workout> get workouts => _workouts;
  bool get isLoading => _isLoading;

  int get totalWorkouts => _workouts.length;
  
  int get totalCalories {
    return _workouts.fold(0, (sum, workout) => sum + workout.calories);
  }
  
  double get averageDuration {
    if (_workouts.isEmpty) return 0;
    int totalDuration = _workouts.fold(0, (sum, workout) => sum + workout.duration);
    return totalDuration / _workouts.length;
  }
  
  double get averageCalories {
    if (_workouts.isEmpty) return 0;
    return totalCalories / _workouts.length;
  }

  Future<void> loadWorkouts({String? token}) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (token == null || token.isEmpty) {
        print('No token available');
        _workouts = [];
        return;
      }
      
      _workouts = await ApiService.getWorkouts(token);
      print('Loaded ${_workouts.length} workouts');
    } catch (e) {
      print('Error loading workouts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addWorkout(Workout workout, String token) async {
    if (token.isEmpty) {
      print('No token available');
      return;
    }
    
    try {
      final newWorkout = await ApiService.addWorkout(workout, token);
      _workouts.add(newWorkout);
      notifyListeners();
    } catch (e) {
      print('Error adding workout: $e');
      rethrow;
    }
  }

  Future<void> updateWorkout(String id, Workout workout, String token) async {
    try {
      final updatedWorkout = await ApiService.updateWorkout(id, workout, token);
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

  Future<void> removeWorkout(String id, String token) async {
    try {
      await ApiService.deleteWorkout(id, token);
      _workouts.removeWhere((w) => w.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting workout: $e');
      rethrow;
    }
  }

  Future<void> deleteWorkout(String id, String token) async {
    await removeWorkout(id, token);
  }
}