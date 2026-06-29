import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_tracker/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('fromJson parses profile fields', () {
      final profile = UserProfile.fromJson({
        '_id': 'user-1',
        'fullName': 'Alice Smith',
        'email': 'alice@example.com',
        'age': 28,
        'weightKg': 62,
        'heightCm': 168,
        'fitnessGoal': 'Lose weight',
      });

      expect(profile.fullName, 'Alice Smith');
      expect(profile.email, 'alice@example.com');
      expect(profile.age, 28);
      expect(profile.weightKg, 62);
      expect(profile.heightCm, 168);
      expect(profile.fitnessGoal, 'Lose weight');
    });

    test('toJson returns serializable data', () {
      final profile = UserProfile(
        id: 'user-1',
        fullName: 'Alice Smith',
        email: 'alice@example.com',
        age: 28,
        weightKg: 62,
        heightCm: 168,
        fitnessGoal: 'Lose weight',
      );

      final json = profile.toJson();

      expect(json['fullName'], 'Alice Smith');
      expect(json['email'], 'alice@example.com');
      expect(json['age'], 28);
      expect(json['weightKg'], 62);
      expect(json['heightCm'], 168);
      expect(json['fitnessGoal'], 'Lose weight');
    });
  });
}
