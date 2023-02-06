import 'package:flutter/material.dart';

import 'components/dialog_box.dart';
import 'components/todo_tile.dart';

void main() {
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
  // textfield controller
  final _controller = TextEditingController();

  List toDoList = [
    ["Install this app", true],
    ["Add new tasks", false],
  ];

  // checkbox tap
  void checkBoxOnChange(bool? value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  // save new task
  void saveNewTask() {
    setState(() {
      toDoList.add([_controller.text, false]);
      _controller.clear();
    });
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
      toDoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // https://youtu.be/mMgr47QBZWA?t=818
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yapılacaklar Listesi'),
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
              itemCount: toDoList.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  taskName: toDoList[index][0],
                  taskState: toDoList[index][1],
                  onChanged: (value) => checkBoxOnChange(value, index),
                  deleteTask: (context) => deleteTask(index),
                );
              },
            )),
      ),
    );
  }
}
