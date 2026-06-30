class UserProfile {
  final String? id;
  final String fullName;
  final String email;
  final String? profileImage;
  final int? age;
  final double? weightKg;
  final double? heightCm;
  final String? fitnessGoal;

  UserProfile({
    this.id,
    required this.fullName,
    required this.email,
    this.profileImage,
    this.age,
    this.weightKg,
    this.heightCm,
    this.fitnessGoal,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      fullName: json['fullName']?.toString() ?? json['name']?.toString() ?? 'User',
      email: json['email']?.toString() ?? '',
      profileImage: json['profileImage']?.toString(),  // ADDED
      age: json['age'] is int ? json['age'] : int.tryParse(json['age']?.toString() ?? ''),
      weightKg: json['weightKg'] is num ? (json['weightKg'] as num).toDouble() : null,
      heightCm: json['heightCm'] is num ? (json['heightCm'] as num).toDouble() : null,
      fitnessGoal: json['fitnessGoal']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      if (profileImage != null) 'profileImage': profileImage,  // ADDED
      if (age != null) 'age': age,
      if (weightKg != null) 'weightKg': weightKg,
      if (heightCm != null) 'heightCm': heightCm,
      if (fitnessGoal != null) 'fitnessGoal': fitnessGoal,
    };
  }
}