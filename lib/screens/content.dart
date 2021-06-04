import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/authentication.dart';
import '../utils/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo.dart';
import '../widgets/loading.dart';
import './items.dart';

class Content extends StatefulWidget {
  const Content({Key key, User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  User _user;
  DatabaseService _db;
  final Authentication _auth = Authentication();

  @override
  void initState() {
    super.initState();
    _user = widget._user;
  }

  void _addItem(DatabaseService db) async {
    var item = await _db.addItem('GraphQL', 'Learn GraphQL ASAP', false);
    print(item.id);
    print(item.data);
  }

  @override
  Widget build(BuildContext context) {
    _db = DatabaseService(uid: _user.uid);
    final items = Provider.of<List<Todo>>(context);
    print(items.toString());
    if (items == null) {
      return Loading();
    } else {
      if (items.length == 0) {
        return Scaffold(
          appBar: AppBar(
            title: Text("TODO"),
            actions: [
              FlatButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.person),
                label: Text('Sign Out'),
              )
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You don\'t have anything in the to-do list:',
                ),
                Text(
                  'Add your to-do item by clicking on the + icon below',
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _addItem(_db);
            },
            tooltip: 'Add Item',
            child: Icon(Icons.add),
          ),
        );
      } else {
        return Items(user: _user);
      }
    }
  }
}
