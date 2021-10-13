import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Welcome to Flutter', home: TodoList());
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  List todos = [];
  int _selectIndex = 0;
  String value = '';
  _addTodo() {
    setState(() {
      todos.insert(todos.length, value);
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      todos.remove(todos[index]);
    });
  }

  Future showDeleteConfirmDialog1() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("添加"),
          content: TextField(
            onChanged: (v) {
              setState(() {
                value = v;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("确定"),
              onPressed: () => Navigator.of(context).pop(_addTodo()), // 关闭对话框
            ),
            TextButton(
              child: const Text("取消"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('todo list'),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  await showDeleteConfirmDialog1();
                },
                child: const Text('添加'),
                style: TextButton.styleFrom(
                    primary: Theme.of(context).colorScheme.onPrimary))
          ],
        ),
        body: Container(
            margin: const EdgeInsets.all(20),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return (ListTile(
                  title: Wrap(children: [
                    Text(todos[index]),
                    TextButton(
                        onPressed: () {
                          _deleteTodo(index);
                        },
                        child: const Icon(Icons.delete))
                  ], alignment: WrapAlignment.spaceBetween),
                  selected: index == _selectIndex,
                  onTap: () {
                    setState(() {
                      _selectIndex = index;
                    });
                  },
                ));
              },
              itemCount: todos.length,
            )));
  }
}
