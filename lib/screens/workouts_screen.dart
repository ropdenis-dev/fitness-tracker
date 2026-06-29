import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import 'workout_detail_screen.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final workouts = workoutProvider.workouts;
    final isLoading = workoutProvider.isLoading;
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'My workouts',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => workoutProvider.loadWorkouts(),
                  icon: const Icon(Icons.refresh_outlined),
                  tooltip: 'Refresh workouts',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Track your recent sessions and jump back in quickly.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : workouts.isEmpty
                      ? Center(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.fitness_center, size: 56, color: theme.colorScheme.primary),
                                  const SizedBox(height: 12),
                                  Text('No workouts yet', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Text('Add one to start building your routine.', style: theme.textTheme.bodyMedium),
                                ],
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: workouts.length,
                          itemBuilder: (context, index) {
                            final workout = workouts[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => WorkoutDetailScreen(workout: workout)),
                                  );
                                },
                                title: Text(workout.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('${workout.duration} min • ${workout.calories} kcal'),
                                trailing: Text(
                                  '${workout.date.day}/${workout.date.month}/${workout.date.year}',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}