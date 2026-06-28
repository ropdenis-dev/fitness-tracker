import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout.dart';

class WorkoutProvider extends ChangeNotifier {
  static const String _storageKey = 'fitness_tracker_workouts';

  List<Workout> _workouts = [];

  WorkoutProvider() {
    _loadWorkouts();
  }

  List<Workout> get workouts => _workouts;

  Future<void> _loadWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_storageKey);
    if (stored != null && stored.isNotEmpty) {
      _workouts = Workout.listFromJson(stored);
    } else {
      _workouts = [
        Workout(
          id: '1',
          name: 'Morning Yoga',
          duration: 30,
          calories: 120,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Workout(
          id: '2',
          name: 'Evening Run',
          duration: 45,
          calories: 350,
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Workout(
          id: '3',
          name: 'Strength Training',
          duration: 50,
          calories: 280,
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
      await _saveWorkouts();
    }
    notifyListeners();
  }

  Future<void> _saveWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, Workout.listToJson(_workouts));
  }

  void addWorkout(Workout workout) {
    _workouts.add(workout);
    _saveWorkouts();
    notifyListeners();
  }

  void removeWorkout(String id) {
    _workouts.removeWhere((workout) => workout.id == id);
    _saveWorkouts();
    notifyListeners();
  }

  int get totalCalories =>
      _workouts.fold(0, (sum, workout) => sum + workout.calories);

  int get totalWorkouts => _workouts.length;

  double get averageDuration =>
      _workouts.isEmpty ? 0 : _workouts.map((w) => w.duration).reduce((a, b) => a + b) / _workouts.length;
}
