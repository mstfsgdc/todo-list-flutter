import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [];

  // referance the box
  final _myToDoBox = Hive.box('myToDoBox');

  // first time list
  void createInitialData() {
    toDoList = [
      ["Install this app", true],
      ["Add new task(s)", false],
    ];
  }

  // load the tasks from the database
  void loadData() {
    toDoList = _myToDoBox.get("TODOLIST");
  }

  // updata database
  void updateDatabase() {
    _myToDoBox.put("TODOLIST", toDoList);
  }
}
