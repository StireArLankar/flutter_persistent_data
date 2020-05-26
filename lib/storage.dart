import 'dart:io';

import 'package:device_info/device_info.dart';

import 'typed.dart';
import 'models/User.dart';

class Storage {
  User _user;
  String _deviceId;

  User get user => _user;

  final Repository _repository;

  static Future<Storage> create({Repository repository}) async {
    final ret = Storage(repository);
    ret._user = await ret.getUser();

    return ret;
  }

  Storage(this._repository, [User _user]);

  Future<String> deviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    var deviceId = '';

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.androidId;
    } else {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }

    return deviceId;
  }

  Future<void> saveUser(User user) async {
    _deviceId = await deviceId();

    final photoLocation = await _repository.saveImage(
      _deviceId,
      'avatar.jpg',
      user.photo,
    );

    user.photoUrl = photoLocation;

    await _repository.saveString(_deviceId, 'user.name', user.name);
    await _repository.saveString(_deviceId, 'user.id', user.id);
    await _repository.saveString(_deviceId, 'user.photoUrl', user.photoUrl);

    _user = user;
    return;
  }

  Future<User> getUser() async {
    _deviceId = await deviceId();

    final name = await _repository.getString(_deviceId, 'user.name');
    final id = await _repository.getString(_deviceId, 'user.id');
    final url = await _repository.getString(_deviceId, 'user.photoUrl');
    final photo = await _repository.getImage(_deviceId, 'avatar.jpg');

    if (name == null) {
      return null;
    }

    final user = User(name: name, id: id, photoUrl: url, photo: photo);

    return user;
  }

  void logout() async {
    _deviceId = await deviceId();

    await _repository.removeImage(_deviceId, 'avatar.jpg');
    await _repository.removeString(_deviceId, 'user.name');
    await _repository.removeString(_deviceId, 'user.id');
    await _repository.removeString(_deviceId, 'user.photoUrl');

    _user = null;
  }
}
