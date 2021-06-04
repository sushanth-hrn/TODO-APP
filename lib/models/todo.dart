class Todo {
  String itemId;
  String title;
  String description;
  DateTime creation;
  DateTime completion;
  bool completed;
  String uid;

  Todo(
      {this.itemId,
      this.title,
      this.description,
      this.creation,
      this.completion,
      this.completed,
      this.uid});
}
