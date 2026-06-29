import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/workout.dart';

class ApiService {
  // Your live API URL
  static const String baseUrl = 'https://fitness-tracker-two-fawn.vercel.app';

  // Get all workouts
  static Future<List<Workout>> getWorkouts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/workouts'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Workout.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load workouts');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Add a new workout
  static Future<Workout> addWorkout(Workout workout) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/workouts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(workout.toJson()),
      );

      if (response.statusCode == 201) {
        return Workout.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add workout');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update a workout
  static Future<Workout> updateWorkout(String id, Workout workout) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/workouts/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(workout.toJson()),
      );

      if (response.statusCode == 200) {
        return Workout.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update workout');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Delete a workout
  static Future<void> deleteWorkout(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/workouts/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete workout');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}