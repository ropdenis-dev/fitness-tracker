import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkoutProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildStatCard('Total Workouts', provider.totalWorkouts.toString()),
            _buildStatCard('Total Calories Burned', provider.totalCalories.toString()),
            _buildStatCard('Average Duration', "${provider.averageDuration.toStringAsFixed(0)} min"),
            _buildStatCard('Average Calories', "${provider.averageCalories.toStringAsFixed(0)} cal"),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}