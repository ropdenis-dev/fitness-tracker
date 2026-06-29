import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/workout.dart';
import '../services/api_service.dart';

class WorkoutProvider extends ChangeNotifier {
  List<Workout> _workouts = [];
  bool _isLoading = false;
  String? _currentUserId;

  List<Workout> get workouts => _workouts;
  bool get isLoading => _isLoading;

  // ===== STATISTICS GETTERS =====
  
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

  // ===== API METHODS =====

  Future<void> loadWorkouts({String? userId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final uid = userId ?? FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        print('No user ID available');
        _workouts = [];
        return;
      }
      
      _currentUserId = uid;
      _workouts = await ApiService.getWorkouts(uid);
      print('SUCCESS: Loaded ${_workouts.length} workouts for user $uid');
    } catch (e) {
      print('Error loading workouts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addWorkout(Workout workout) async {
    if (_currentUserId == null) {
      print('No user ID available');
      return;
    }
    
    try {
      final workoutWithUser = workout.copyWith(userId: _currentUserId);
      final newWorkout = await ApiService.addWorkout(workoutWithUser);
      _workouts.add(newWorkout);
      notifyListeners();
    } catch (e) {
      print('Error adding workout: $e');
      rethrow;
    }
  }

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

  Future<void> deleteWorkout(String id) async {
    await removeWorkout(id);
  }
}