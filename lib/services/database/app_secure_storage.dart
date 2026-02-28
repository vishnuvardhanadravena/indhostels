import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSecureStorage {
  final FlutterSecureStorage _storage;

  AppSecureStorage(this._storage);

  /// ================== WRITE ==================

  Future<void> writeString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> writeInt(String key, int value) async {
    await _storage.write(key: key, value: value.toString());
  }

  Future<void> writeBool(String key, bool value) async {
    await _storage.write(key: key, value: value.toString());
  }

  Future<void> writeMap(String key, Map<String, dynamic> value) async {
    await _storage.write(key: key, value: jsonEncode(value));
  }

  Future<void> writeList(String key, List value) async {
    await _storage.write(key: key, value: jsonEncode(value));
  }

  /// Generic Write (Any Model)
  Future<void> writeObject(String key, dynamic value) async {
    await _storage.write(key: key, value: jsonEncode(value));
  }

  /// ================== READ ==================

  Future<String?> readString(String key) async {
    return await _storage.read(key: key);
  }

  Future<int?> readInt(String key) async {
    final value = await _storage.read(key: key);
    return value != null ? int.tryParse(value) : null;
  }

  Future<bool?> readBool(String key) async {
    final value = await _storage.read(key: key);
    return value != null ? value == "true" : null;
  }

  Future<Map<String, dynamic>?> readMap(String key) async {
    final value = await _storage.read(key: key);
    return value != null ? jsonDecode(value) : null;
  }

  Future<List?> readList(String key) async {
    final value = await _storage.read(key: key);
    return value != null ? jsonDecode(value) : null;
  }

  /// Generic Read
  Future<T?> readObject<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final value = await _storage.read(key: key);
    if (value == null) return null;

    final decoded = jsonDecode(value);
    return fromJson(decoded);
  }

  /// ================== DELETE ==================

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
