import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'components/dialog_box.dart';
import 'components/todo_tile.dart';
import 'data/database.dart';

void main() async {
  // init hive
  await Hive.initFlutter();

  // open a box
  await Hive.openBox("myToDoBox");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _myToDoBox = Hive.box('myToDoBox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    if (_myToDoBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  // textfield controller
  final _controller = TextEditingController();

  // checkbox tap
  void checkBoxOnChange(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDatabase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    db.updateDatabase();
    Navigator.of(context).pop();
  }

  // create new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    // https://youtu.be/mMgr47QBZWA?t=818
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [
            Text('To-Do List'),
            Text(
              'v1.0',
              style: TextStyle(fontSize: 9.0),
            )
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: Container(
        color: Colors.black12,
        child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: ListView.builder(
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  taskName: db.toDoList[index][0],
                  taskState: db.toDoList[index][1],
                  onChanged: (value) => checkBoxOnChange(value, index),
                  deleteTask: (context) => deleteTask(index),
                );
              },
            )),
      ),
    );
  }
}
