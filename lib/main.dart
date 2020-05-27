import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'Storage.dart';
import 'file_storage.dart';
import 'local_storage.dart';
import 'models/App.dart';
import 'screens/login_page.dart';
import 'screens/inner_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static var provider = App(null);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Storage>(
      future: Storage.create(repository: FileStorage()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final repository = snapshot.data;
          provider = App(repository);

          return MultiProvider(
            providers: [ChangeNotifierProvider.value(value: provider)],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: Color(0xff006837),
                primaryColorDark: Color(0xff004012),
                accentColor: Color(0xffc75f00),
              ),
              home: provider.user == null ? LoginPage() : InnerPage(),
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (ctx) => _buildRoute(context, settings.name),
                  maintainState: true,
                  fullscreenDialog: false,
                );
              },
            ),
          );
        }
        return MaterialApp(
          theme: ThemeData(),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
            backgroundColor: Color(0xff006837),
          ),
        );
      },
    );
  }

  Widget _buildRoute(BuildContext context, String routeName) {
    switch (routeName) {
      case '/login':
        return LoginPage();
      case '/shop':
        return InnerPage();
      default:
        return Container();
    }
  }
}
