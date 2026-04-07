// ============================================
// Dosya: base_repository.dart
// Amaç: Generic Firestore CRUD soyutlama — tüm repository'ler bunu extend eder
// Bağımlılıklar: cloud_firestore
// ============================================

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/utils/logger.dart';

abstract class BaseRepository<T> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Alt sınıf bu değerleri override edecek
  String get collectionPath;
  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T item);

  CollectionReference<Map<String, dynamic>> get collection =>
      _firestore.collection(collectionPath);

  /// CREATE
  Future<String> create(T item) async {
    try {
      final doc = await collection.add(toJson(item));
      AppLogger.info('Created: ${doc.id}', tag: collectionPath);
      return doc.id;
    } catch (e) {
      AppLogger.error('Create failed', tag: collectionPath, error: e);
      rethrow;
    }
  }

  /// CREATE with custom ID
  Future<void> createWithId(String id, T item) async {
    try {
      await collection.doc(id).set(toJson(item));
      AppLogger.info('Created with ID: $id', tag: collectionPath);
    } catch (e) {
      AppLogger.error('Create with ID failed', tag: collectionPath, error: e);
      rethrow;
    }
  }

  /// READ — tek döküman
  Future<T?> getById(String id) async {
    try {
      final doc = await collection.doc(id).get();
      if (!doc.exists) return null;
      final data = doc.data()!;
      data['id'] = doc.id;
      return fromJson(data);
    } catch (e) {
      AppLogger.error('GetById failed: $id', tag: collectionPath, error: e);
      rethrow;
    }
  }

  /// READ — tüm dökümanlar
  Future<List<T>> getAll({int? limit}) async {
    try {
      Query<Map<String, dynamic>> query = collection;
      if (limit != null) query = query.limit(limit);
      
      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return fromJson(data);
      }).toList();
    } catch (e) {
      AppLogger.error('GetAll failed', tag: collectionPath, error: e);
      rethrow;
    }
  }

  /// UPDATE
  Future<void> update(String id, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = DateTime.now().toIso8601String();
      await collection.doc(id).update(data);
      AppLogger.info('Updated: $id', tag: collectionPath);
    } catch (e) {
      AppLogger.error('Update failed: $id', tag: collectionPath, error: e);
      rethrow;
    }
  }

  /// DELETE
  Future<void> delete(String id) async {
    try {
      await collection.doc(id).delete();
      AppLogger.info('Deleted: $id', tag: collectionPath);
    } catch (e) {
      AppLogger.error('Delete failed: $id', tag: collectionPath, error: e);
      rethrow;
    }
  }

  /// STREAM — real-time değişiklikleri dinle
  Stream<List<T>> stream({int? limit}) {
    Query<Map<String, dynamic>> query = collection;
    if (limit != null) query = query.limit(limit);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return fromJson(data);
      }).toList();
    });
  }

  /// QUERY — filtrelenmiş sorgulama
  Future<List<T>> query({
    required String field,
    required dynamic isEqualTo,
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    try {
      Query<Map<String, dynamic>> q = collection.where(field, isEqualTo: isEqualTo);
      if (orderBy != null) q = q.orderBy(orderBy, descending: descending);
      if (limit != null) q = q.limit(limit);

      final snapshot = await q.get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return fromJson(data);
      }).toList();
    } catch (e) {
      AppLogger.error('Query failed', tag: collectionPath, error: e);
      rethrow;
    }
  }
}
