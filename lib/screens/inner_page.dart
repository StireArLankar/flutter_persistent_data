import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../widgets/AvatarImageView.dart';
import '../models/App.dart';

class InnerPage extends StatefulWidget {
  @override
  _InnerPageState createState() => _InnerPageState();
}

class _InnerPageState extends State<InnerPage> {
  final database = getDatabasesPath().then<Database>((pth) {
    return openDatabase(
      join(pth, 'test.db'),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE dates(id INTEGER PRIMARY KEY, date TEXT, name TEXT)");
      },
      version: 1,
    );
  });

  List<Map<String, dynamic>> dbItems = [];

  Future<List<Map<String, dynamic>>> get items async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('dates');

    return List.generate(maps.length, (i) {
      return {
        "id": maps[i]['id'],
        "date": maps[i]['date'] ?? DateTime.now(),
        "name": maps[i]['name'] ?? "unknown name",
      };
    });
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      dbItems = await items;
      final app = Provider.of<App>(context, listen: false);
      addItem(app.storage.user.name);
    });
  }

  Future<void> addItem(String name) async {
    final Database db = await database;

    final lastId = dbItems.length == 0 ? 0 : dbItems.last['id'];

    final temp = {"id": lastId + 1, "date": DateTime.now().toIso8601String(), "name": name};

    try {
      await db.insert(
        'dates',
        temp,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      setState(() => dbItems.add(temp));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<App>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Inner Page')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.plus_one),
        onPressed: () => addItem(app.storage.user.name),
      ),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemBuilder: (ctx, i) {
                    final date = DateFormat('yyyy-MM-dd – kk:mm')
                        .format(DateTime.tryParse(dbItems[i]['date']));
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purple[100],
                      ),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: <Widget>[
                          Text(dbItems[i]['id'].toString()),
                          Expanded(child: Text(date, textAlign: TextAlign.center)),
                          Text(dbItems[i]['name'].toString()),
                        ],
                      ),
                    );
                  },
                  itemCount: dbItems.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
