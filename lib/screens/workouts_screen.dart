import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import 'workout_detail_screen.dart';

class WorkoutsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, child) {
        final workouts = provider.workouts;
        if (workouts.isEmpty) {
          return const Center(child: Text('No workouts yet. Add one!'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutDetailScreen(workout: workout),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  title: Text(workout.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text('${workout.duration} min - ${workout.calories} kcal'),
                  trailing: Text(
                    '${workout.date.day}/${workout.date.month}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}