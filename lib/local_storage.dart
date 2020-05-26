import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

import 'typed.dart';

class LocalKeyValuePersistence implements Repository {
  String _generateKey(String userId, String key) => '$userId/$key';

  @override
  Future<String> saveImage(String userId, String key, Uint8List image) async {
    final base64Image = Base64Encoder().convert(image);

    final prefs = await SharedPreferences.getInstance();

    final generatedKey = _generateKey(userId, key);

    await prefs.setString(generatedKey, base64Image);

    return generatedKey;
  }

  @override
  Future<String> saveObject(
    String userId,
    String key,
    Map<String, dynamic> object,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final generatedKey = _generateKey(userId, key);

    final string = JsonEncoder().convert(object);

    await prefs.setString(_generateKey(userId, key), string);

    return generatedKey;
  }

  @override
  Future<String> saveString(String userId, String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    final generatedKey = _generateKey(userId, key);

    await prefs.setString(_generateKey(userId, key), value);

    return generatedKey;
  }

  @override
  Future<Uint8List> getImage(String userId, String key) async {
    final prefs = await SharedPreferences.getInstance();

    final base64Image = prefs.getString(_generateKey(userId, key));

    if (base64Image != null) {
      return Base64Decoder().convert(base64Image);
    }

    return null;
  }

  @override
  Future<Map<String, dynamic>> getObject(String userId, String key) async {
    final prefs = await SharedPreferences.getInstance();

    final objectString = prefs.getString(_generateKey(userId, key));

    if (objectString != null) {
      return JsonDecoder().convert(objectString) as Map<String, dynamic>;
    }

    return null;
  }

  @override
  Future<String> getString(String userId, String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_generateKey(userId, key));
  }

  @override
  Future<bool> removeImage(String userId, String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.remove(_generateKey(userId, key));
  }

  @override
  Future<bool> removeObject(String userId, String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.remove(_generateKey(userId, key));
  }

  @override
  Future<bool> removeString(String userId, String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.remove(_generateKey(userId, key));
  }
}
