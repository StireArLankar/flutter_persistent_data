import 'package:flutter/material.dart';
import '../widgets/AvatarImageView.dart';
import '../models/App.dart';
import 'package:provider/provider.dart';

class InnerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<App>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Inner Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AvatarImageView(
              name: app.storage.user.name,
              photo: app.storage.user.photo,
            ),
            MaterialButton(
              child: Text('Logout'),
              onPressed: () async {
                await app.logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
