import 'dart:typed_data';

abstract class Repository {
  Future<String> saveString(String userId, String key, String value);

  Future<String> saveImage(String userId, String key, Uint8List image);

  Future<String> saveObject(
    String userId,
    String key,
    Map<String, dynamic> object,
  );

  Future<String> getString(String userId, String key);

  Future<Uint8List> getImage(String userId, String key);

  Future<Map<String, dynamic>> getObject(String userId, String key);

  Future<bool> removeString(String userId, String key);

  Future<bool> removeImage(String userId, String key);

  Future<bool> removeObject(String userId, String key);
}
