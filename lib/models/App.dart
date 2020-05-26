import 'package:flutter/material.dart';

import '../Storage.dart';
import 'User.dart';

class App with ChangeNotifier {
  App(this._storage);

  final Storage _storage;

  Storage get storage => _storage;

  User get user => _storage?.user;

  void refresh() {
    notifyListeners();
  }

  Future<void> logout() async => _storage.logout();
}
