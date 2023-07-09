import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    // Initialize tasks from a persistent storage (e.g., database)
    tasks = [
      Task('Buy groceries', DateTime.now().add(Duration(days: 1)), Priority.High),
      Task('Call John', DateTime.now().add(Duration(hours: 3)), Priority.Medium),
      Task('Finish project', DateTime.now().add(Duration(days: 5)), Priority.Low),
    ];
  }

  void addTask(String title, DateTime dueDate, Priority priority) {
    setState(() {
      tasks.add(Task(title, dueDate, priority));
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void toggleTaskStatus(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          Task task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(DateFormat('MMM dd, yyyy').format(task.dueDate)),
            trailing: Checkbox(
              value: task.isCompleted,
              onChanged: (bool? value) => toggleTaskStatus(index),
            ),
            onTap: () => deleteTask(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController titleController = TextEditingController();
              DateTime? dueDate;

              return AlertDialog(
                title: Text('Add Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (selectedDate != null) {
                          setState(() {
                            dueDate = selectedDate;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          dueDate!= null
                              ? DateFormat('MMM dd, yyyy').format(dueDate!)
                              : 'Select due date',
                        ),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Add'),
                    onPressed: () {
                      if (titleController.text.isNotEmpty && dueDate != null) {
                        addTask(
                          titleController.text,
                          dueDate!,
                          Priority.Low,
                        );
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

enum Priority {
  Low,
  Medium,
  High,
}

class Task {
  final String title;
  final DateTime dueDate;
  final Priority priority;
  bool isCompleted;

  Task(this.title, this.dueDate, this.priority, {this.isCompleted = false});
}

