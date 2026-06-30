class Workout {
  final String? id;
  final String? userId;
  final String name;
  final int duration;
  final int calories;
  final int waterIntake;  // NEW: Added water intake field
  final DateTime date;

  Workout({
    this.id,
    this.userId,
    required this.name,
    required this.duration,
    required this.calories,
    this.waterIntake = 0,  // Default to 0 if not provided
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Workout copyWith({
    String? userId,
    int? waterIntake,
  }) {
    return Workout(
      id: id,
      userId: userId ?? this.userId,
      name: name,
      duration: duration,
      calories: calories,
      waterIntake: waterIntake ?? this.waterIntake,
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
      waterIntake: json['waterIntake'] ?? 0,
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'duration': duration,
      'calories': calories,
      'waterIntake': waterIntake,
      'date': date.toIso8601String(),
      if (userId != null) 'userId': userId,
    };
  }
}