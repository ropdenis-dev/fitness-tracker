class Workout {
  final String? id;
  final String? userId;
  final String name;
  final int duration;
  final int calories;
  final DateTime date;

  Workout({
    this.id,
    this.userId,
    required this.name,
    required this.duration,
    required this.calories,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  // Create a copy of the workout with userId
  Workout copyWith({String? userId}) {
    return Workout(
      id: id,
      userId: userId ?? this.userId,
      name: name,
      duration: duration,
      calories: calories,
      date: date,
    );
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['_id'] ?? json['id'],
      userId: json['userId'],
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
      if (userId != null) 'userId': userId,
    };
  }
}