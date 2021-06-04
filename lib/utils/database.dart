import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference todo =
      FirebaseFirestore.instance.collection('todo');

  List<Todo> _toCustomTodo(QuerySnapshot snap) {
    return snap.docs.map((doc) {
      print('yooo');
      // var data = doc.data();
      // print(doc['title']);
      print(doc);
      print(doc.data());
      DateTime createdOn = doc['creation']?.toDate();
      DateTime completedOn = doc['completion']?.toDate();
      return Todo(
          itemId: doc.id,
          title: doc['title'],
          description: doc['description'],
          creation: createdOn,
          completion: completedOn,
          completed: doc['completed'],
          uid: doc['id']);
    }).toList();
  }

  Stream<List<Todo>> get items {
    return todo.where('id', isEqualTo: uid).snapshots().map((snapshot) {
      print(snapshot.docs.map((doc) => doc.data()));
      return _toCustomTodo(snapshot);
    });
  }

  Future addItem(String title, String description, bool completed) async {
    Timestamp creationTimestamp = Timestamp.now();
    Timestamp completionTimestamp = Timestamp.now();
    return await todo.add({
      'id': uid,
      'title': title,
      'description': description,
      'creation': creationTimestamp,
      'completion': completionTimestamp,
      'completed': completed
    });
  }

  Future updateItem(String docId,
      {String title, String description, bool completed}) async {
    return await todo.doc(docId).update(
        {'title': title, 'description': description, 'completed': completed});
  }

  deleteItem(String docId) {
    todo.doc(docId).delete().then((value) => print("Deleted successfully"));
  }
}

// todo
//         .where("id", isEqualTo: uid)
//         .orderBy("creation", descending: true)
//         .snapshots()
//         .map(_toCustomTodo);
