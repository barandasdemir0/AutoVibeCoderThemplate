// ============================================
// Dosya: user_model_test.dart
// Amaç: UserModel unit testleri — fromJson, toJson, copyWith, equality
// Bağımlılıklar: flutter_test, user_model.dart
// ============================================

import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    final testJson = {
      'id': 'test-id-123',
      'email': 'test@test.com',
      'name': 'Test User',
      'photoUrl': 'https://example.com/photo.jpg',
      'createdAt': '2024-01-01T00:00:00.000Z',
      'updatedAt': null,
    };

    test('fromJson creates UserModel correctly', () {
      final user = UserModel.fromJson(testJson);

      expect(user.id, 'test-id-123');
      expect(user.email, 'test@test.com');
      expect(user.name, 'Test User');
      expect(user.photoUrl, 'https://example.com/photo.jpg');
      expect(user.createdAt, isA<DateTime>());
    });

    test('toJson returns correct Map', () {
      final user = UserModel.fromJson(testJson);
      final json = user.toJson();

      expect(json['id'], 'test-id-123');
      expect(json['email'], 'test@test.com');
      expect(json['name'], 'Test User');
    });

    test('copyWith updates specific fields', () {
      final user = UserModel.fromJson(testJson);
      final updated = user.copyWith(name: 'New Name');

      expect(updated.name, 'New Name');
      expect(updated.email, user.email); // Değişmemeli
      expect(updated.id, user.id); // Değişmemeli
    });

    test('fromJson handles missing fields gracefully', () {
      final minimalJson = {'id': '1', 'email': 'a@b.com', 'name': 'A'};
      final user = UserModel.fromJson(minimalJson);

      expect(user.id, '1');
      expect(user.photoUrl, isNull);
    });

    test('equality based on id', () {
      final user1 = UserModel.fromJson(testJson);
      final user2 = UserModel.fromJson(testJson);

      expect(user1, equals(user2));
    });
  });
}
