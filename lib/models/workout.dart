class Workout {
  final String? id;
  final String name;
  final int duration;
  final int calories;
  final DateTime date;

  Workout({
    this.id,
    required this.name,
    required this.duration,
    required this.calories,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['_id'],
      name: json['name'],
      duration: json['duration'],
      calories: json['calories'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'duration': duration,
      'calories': calories,
      'date': date.toIso8601String(),
    };
  }
}