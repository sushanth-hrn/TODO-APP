import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/database.dart';
import '../utils/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo.dart';
import './sign_in.dart';
import '../widgets/form.dart';

class Items extends StatefulWidget {
  const Items({Key key, User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  _ItemsState createState() => _ItemsState();
}

//enum com { Yes, No }

class _ItemsState extends State<Items> {
  User _user;
  DatabaseService _db;
  final Authentication _auth = Authentication();
  //com completed;

  @override
  void initState() {
    super.initState();
    _user = widget._user;
  }

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void _addItem(DatabaseService db, bool isEdit, BuildContext context,
      {Todo data}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Popup(db, isEdit, context, item: data);
      },
    );
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
              Navigator.of(context).pushReplacement(_routeToSignInScreen());
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
                      ? Icon(
                          Icons.check_circle_outline_rounded,
                          color: Colors.green,
                          size: 36.0,
                        )
                      : Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                          size: 36.0,
                        ),
                  title: Text(items[index].title),
                  subtitle: Column(
                    children: [
                      Text(items[index].description),
                      Text(
                          "Created on day : ${items[index].creation.day}/${items[index].creation.month}/${items[index].creation.year}  At : ${items[index].creation.hour}:${items[index].creation.minute}:${items[index].creation.second}"),
                      items[index].completed
                          ? Text(
                              "Completed On : ${items[index].completion.day}/${items[index].completion.month}/${items[index].completion.year}  At : ${items[index].completion.hour}:${items[index].completion.minute}:${items[index].completion.second}")
                          : Text("You haven't completed this task yet")
                    ],
                  ),
                  trailing: Wrap(
                    spacing: 5,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await _db.deleteItem(items[index].itemId);
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        focusColor: Colors.purple,
                        splashColor: Colors.red,
                      ),
                      IconButton(
                        onPressed: () {
                          _addItem(_db, true, context, data: items[index]);
                        },
                        icon: Icon(Icons.create_rounded),
                        color: Colors.green,
                        focusColor: Colors.purple,
                        splashColor: Colors.yellow,
                      ),
                    ],
                  )),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addItem(_db, false, context);
        },
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }
}
