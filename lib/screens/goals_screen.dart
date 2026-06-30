import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  int _stepGoal = 10000;
  int _calorieGoal = 2000;
  int _activeDaysGoal = 5;
  int _hydrationGoal = 8;

  final _stepController = TextEditingController();
  final _calorieController = TextEditingController();
  final _activeDaysController = TextEditingController();
  final _hydrationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  @override
  void dispose() {
    _stepController.dispose();
    _calorieController.dispose();
    _activeDaysController.dispose();
    _hydrationController.dispose();
    super.dispose();
  }

  Future<void> _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _stepGoal = prefs.getInt('stepGoal') ?? 10000;
      _calorieGoal = prefs.getInt('calorieGoal') ?? 2000;
      _activeDaysGoal = prefs.getInt('activeDaysGoal') ?? 5;
      _hydrationGoal = prefs.getInt('hydrationGoal') ?? 8;
    });
  }

  Future<void> _saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stepGoal', _stepGoal);
    await prefs.setInt('calorieGoal', _calorieGoal);
    await prefs.setInt('activeDaysGoal', _activeDaysGoal);
    await prefs.setInt('hydrationGoal', _hydrationGoal);
  }

  void _openEditGoalsDialog() {
    _stepController.text = _stepGoal.toString();
    _calorieController.text = _calorieGoal.toString();
    _activeDaysController.text = _activeDaysGoal.toString();
    _hydrationController.text = _hydrationGoal.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Goals'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _stepController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Daily Step Goal'),
              ),
              TextField(
                controller: _calorieController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Calories Goal'),
              ),
              TextField(
                controller: _activeDaysController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Active Days Goal'),
              ),
              TextField(
                controller: _hydrationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Hydration Goal (cups)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _stepGoal = int.tryParse(_stepController.text) ?? _stepGoal;
                  _calorieGoal = int.tryParse(_calorieController.text) ?? _calorieGoal;
                  _activeDaysGoal = int.tryParse(_activeDaysController.text) ?? _activeDaysGoal;
                  _hydrationGoal = int.tryParse(_hydrationController.text) ?? _hydrationGoal;
                });
                _saveGoals();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Goals saved successfully')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGoalCard(String title, String value, String helpText, Color color, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(value, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(helpText, style: textTheme.bodyMedium),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Goals', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildGoalCard('Daily Step Goal', '$_stepGoal steps', 'Keep your daily activity consistent.', theme.colorScheme.secondaryContainer, theme.textTheme),
            const SizedBox(height: 16),
            _buildGoalCard('Calories Goal', '$_calorieGoal kcal', 'Aim to burn this amount daily.', theme.colorScheme.tertiaryContainer, theme.textTheme),
            const SizedBox(height: 16),
            _buildGoalCard('Weekly Active Days', '$_activeDaysGoal days', 'Stay active most days of the week.', theme.colorScheme.primaryContainer, theme.textTheme),
            const SizedBox(height: 16),
            _buildGoalCard('Hydration Goal', '$_hydrationGoal cups', 'Stay hydrated throughout the day.', theme.colorScheme.secondaryContainer, theme.textTheme),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _openEditGoalsDialog,
              child: const Text('Edit Goals'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            ),
          ],
        ),
      ),
    );
  }
}