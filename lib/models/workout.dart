import 'dart:convert';

class Workout {
  final String id;
  final String name;
  final int duration; // in minutes
  final int calories;
  final DateTime date;

  Workout({
    required this.id,
    required this.name,
    required this.duration,
    required this.calories,
    required this.date,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      name: json['name'] as String,
      duration: json['duration'] as int,
      calories: json['calories'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'calories': calories,
      'date': date.toIso8601String(),
    };
  }

  static List<Workout> listFromJson(String source) {
    final parsed = json.decode(source) as List<dynamic>;
    return parsed
        .map((item) => Workout.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static String listToJson(List<Workout> workouts) {
    final list = workouts.map((workout) => workout.toJson()).toList();
    return json.encode(list);
  }
}