import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/database.dart';
import '../utils/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo.dart';

class Items extends StatefulWidget {
  const Items({Key key, User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  User _user;
  DatabaseService _db;
  final Authentication _auth = Authentication();
  @override
  void initState() {
    super.initState();
    _user = widget._user;
  }

  void _addItem(DatabaseService db) async {
    var item = await db.addItem('GraphQL', 'Learn GraphQL ASAP', false);
    print(item.id);
  }

  @override
  Widget build(BuildContext context) {
    _db = DatabaseService(uid: _user.uid);
    final items = Provider.of<List<Todo>>(context);
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
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: items[index].completed
                    ? Icon(Icons.arrow_circle_up_rounded)
                    : Icon(Icons.arrow_circle_down_rounded),
                title: Text(items[index].title),
                subtitle: Column(
                  children: [
                    Text(items[index].description),
                    Text(
                        "Created on day : '${items[index].creation.day}' hours : '${items[index].creation.hour}:${items[index].creation.minute}:${items[index].creation.second}'"),
                    // Text(
                    //   "Completed on : ${(items[index].completed ? items[index].completion.day : "You did not finish this task yet")}"
                    // )
                  ],
                ),
                trailing: FlatButton.icon(
                  onPressed: () async {
                    await _db.deleteItem(items[index].itemId);
                  },
                  icon: Icon(Icons.delete),
                  label: Text('del'),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addItem(_db);
        },
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
    ;
  }
}
