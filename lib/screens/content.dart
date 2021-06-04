import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/authentication.dart';
import '../utils/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo.dart';
import '../widgets/loading.dart';
import './items.dart';
import './sign_in.dart';

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

  String title = '';
  String description = '';

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

  @override
  void initState() {
    super.initState();
    _user = widget._user;
  }

  void _addItem(DatabaseService db, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Padding(
              padding: EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                        icon: Icon(Icons.note_add_rounded),
                      ),
                      onChanged: (val) {
                        setState(() {
                          title = val;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Desciption',
                        icon: Icon(Icons.add_comment),
                      ),
                      onChanged: (val) {
                        setState(() {
                          description = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              RaisedButton(
                  child: Text("Submit"),
                  color: Colors.blue,
                  onPressed: () async {
                    dynamic res = await db.addItem(title, description, false);
                    if (res != null) {
                      Navigator.pop(context);
                    }
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _db = DatabaseService(uid: _user.uid);
    final items = Provider.of<List<Todo>>(context);
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
                  Navigator.of(context).pushReplacement(_routeToSignInScreen());
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
              _addItem(_db, context);
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
