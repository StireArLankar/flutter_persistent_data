import 'dart:typed_data';

class User {
  String name;
  String id;
  String photoUrl;

  Uint8List photo;

  User({this.name, this.id, this.photoUrl, this.photo});
}
