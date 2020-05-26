import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class AvatarImageView extends StatelessWidget {
  final String name;
  final Uint8List photo;
  final Color color;

  const AvatarImageView({
    this.name,
    this.photo,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _pickColors();

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(7.0)),
      child: Container(
        color: colors[0],
        child: _buildContent(colors[1]),
      ),
    );
  }

  List<Color> _pickColors() {
    final colors = [
      [Color(0xff6292e6), Color(0xffffffff)],
      [Color(0xffff8484), Color(0xffffffff)],
      [Color(0xfff5a623), Color(0xffffffff)],
      [Color(0xff99bdfb), Color(0xffffffff)],
    ];

    final rand = Random(name.hashCode).nextInt(colors.length);
    return colors[rand];
  }

  Widget _buildContent(Color textColor) {
    return Column(
      children: <Widget>[
        Text(name, style: TextStyle(color: textColor, fontSize: 14)),
        Image.memory(photo, fit: BoxFit.fill)
      ],
    );
  }
}
