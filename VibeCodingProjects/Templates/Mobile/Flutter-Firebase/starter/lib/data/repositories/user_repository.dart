// ============================================
// Dosya: user_repository.dart
// Amaç: User Firestore CRUD — BaseRepository'yi extend eder
// Bağımlılıklar: base_repository.dart, user_model.dart
// ============================================

import '../models/user_model.dart';
import 'base_repository.dart';

class UserRepository extends BaseRepository<UserModel> {
  @override
  String get collectionPath => 'users';

  @override
  UserModel fromJson(Map<String, dynamic> json) => UserModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(UserModel item) => item.toJson();

  /// Email ile kullanıcı bul
  Future<UserModel?> getByEmail(String email) async {
    final results = await query(field: 'email', isEqualTo: email, limit: 1);
    return results.isNotEmpty ? results.first : null;
  }
}
