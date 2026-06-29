import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import 'workout_detail_screen.dart';  // Use full path

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final workouts = workoutProvider.workouts;
    final isLoading = workoutProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workouts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              workoutProvider.loadWorkouts();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : workouts.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No workouts yet. Add one!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          title: Text(
                            workout.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${workout.duration} min - ${workout.calories} kcal',
                          ),
                          trailing: Text(
                            '${workout.date.day}/${workout.date.month}/${workout.date.year}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}