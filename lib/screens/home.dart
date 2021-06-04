import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/authentication.dart';
import '../utils/database.dart';
import '../models/todo.dart';
import 'package:provider/provider.dart';
import './content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User _user;

  @override
  void initState() {
    super.initState();
    _user = widget._user;
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService _db = DatabaseService(uid: _user.uid);
    return StreamProvider<List<Todo>>.value(
      value: _db.items,
      child: Content(user: _user),
    );
  }
}
