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
  String title = '';
  String desc = '';
  loadData() async {
    await dio.post("http://47.96.16.56:7001/api/add_task",
        data: {"title": title, "desc": desc, "token": 1});
    _init();
  }

  deleteTask(int num) async {
    print(num);
    await dio
        .post("http://47.96.16.56:7001/api/delete_task", data: {"id": num});
    _init();
  }

  handleDeleteTask(int num) {
    deleteTask(num);
  }

  _addTodo() {
    loadData();
  }

  Future showDeleteConfirmDialog1() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("添加"),
          content: Column(children: [
            TextField(
              onChanged: (v) {
                setState(() {
                  title = v;
                });
              },
            ),
            TextField(
              onChanged: (v) {
                setState(() {
                  desc = v;
                });
              },
            ),
          ]),
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
                    title: Text(tasks[index]['title']),
                    subtitle: Text(tasks[index]['desc']),
                    trailing: TextButton(
                        onPressed: () {
                          handleDeleteTask(tasks[index]['id']);
                        },
                        child: const Icon(Icons.delete))));
              },
              itemCount: tasks.length,
            )));
  }
}
