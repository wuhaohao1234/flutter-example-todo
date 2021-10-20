import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/painting.dart';

Dio dio = Dio();
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
  List tasks = [];
  String value = '';
  _addTodo() {}
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

  _init() async {
    Response response = await dio.get('http://47.96.16.56:3000/api/tasks');
    var result = jsonDecode(response.toString());
    setState(() {
      tasks = result['data'];
    });
  }

  @override
  void initState() {
    _init();
  }

  @override
  Widget build(BuildContext context) {
    // _init();
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
                    Text(
                      tasks[index]['title'],
                      style: const TextStyle(fontSize: 30),
                    ),
                    Container(
                        child: Text(tasks[index]['desc']),
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(top: 10))
                  ]),
                ));
              },
              itemCount: tasks.length,
            )));
  }
}
