import 'package:flutter/material.dart';
import '../utils/database.dart';
import '../models/todo.dart';

class Popup extends StatefulWidget {
  Popup(DatabaseService dbb, bool isedit, BuildContext cntxt,
      {Todo item, Key key})
      : db = dbb,
        isEdit = isedit,
        cntxt = cntxt,
        data = item,
        super(key: key);

  DatabaseService db;
  bool isEdit;
  BuildContext cntxt;
  Todo data;
  @override
  _PopupState createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  final _formKey = GlobalKey<FormState>();

  String title;
  String description;
  bool completed = false;
  DatabaseService db;
  bool isEdit;
  BuildContext cntxt;
  Todo data;
  bool inp1 = false;
  bool inp2 = false;
  bool inp3 = false;

  dynamic res;

  @override
  void initState() {
    super.initState();
    db = widget.db;
    isEdit = widget.isEdit;
    cntxt = widget.cntxt;
    if (isEdit) {
      data = widget.data;
      title = data.title;
      description = data.description;
      completed = data.completed;
    }
    inp1 = false;
    inp2 = false;
    inp3 = false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit'),
      insetPadding: EdgeInsets.symmetric(vertical: 65.0),
      content: Padding(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: isEdit ? title : '',
                decoration: InputDecoration(
                  labelText: 'Title',
                  icon: Icon(Icons.note_add_rounded),
                ),
                onChanged: (val) {
                  setState(() {
                    title = val;
                    inp1 = true;
                  });
                },
              ),
              TextFormField(
                initialValue: isEdit ? description : '',
                decoration: InputDecoration(
                  labelText: 'Desciption',
                  icon: Icon(Icons.add_comment),
                ),
                onChanged: (val) {
                  setState(() {
                    description = val;
                    inp2 = true;
                  });
                },
              ),
              isEdit
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Completed ?'),
                        SizedBox(
                          width: 10.0,
                        ),
                        Checkbox(
                            activeColor: Colors.green,
                            value: completed,
                            onChanged: (bool value) {
                              setState(() {
                                completed = value;
                                inp3 = true;
                              });
                            }),
                        // Text('Yes'),
                        // Radio<com>(
                        //   value: com.Yes,
                        //   groupValue: completed,
                        //   activeColor: Colors.green,
                        //   onChanged: (com val) {
                        //     setState(() {
                        //       completed = com.Yes;
                        //     });
                        //   },
                        // ),
                        // Text('No'),
                        // Radio<com>(
                        //   value: com.No,
                        //   groupValue: completed,
                        //   activeColor: Colors.red,
                        //   onChanged: (com val) {
                        //     setState(() {
                        //       completed = com.No;
                        //     });
                        //   },
                        // ),
                      ],
                    )
                  : SizedBox(height: 0.0, width: 0.0)
            ],
          ),
        ),
      ),
      actions: [
        RaisedButton(
            child: Text("Submit"),
            color: Colors.indigo,
            onPressed: () async {
              if (isEdit) {
                res = await db.updateItem(data.itemId,
                    title: inp1 ? title : data.title,
                    description: inp2 ? description : data.description,
                    completed: inp3 ? completed : data.completed);
                Navigator.pop(context);
              } else {
                res = await db.addItem(title, description, completed);
              }
              if (res != null) {
                Navigator.pop(cntxt);
              }
            })
      ],
    );
  }
}
