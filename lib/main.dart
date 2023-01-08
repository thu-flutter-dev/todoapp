import 'package:flutter/material.dart';
import 'model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TodoApp",
      home: Scaffold(body: ContentWidget()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ContentWidget extends StatelessWidget {
  ContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: todoList.data
                .map((e) => TodoWidget(content: e.content))
                .toList(),
          ),
        ),
        AddTodoWidget()
      ],
    );
  }
}

class AddTodoWidget extends StatelessWidget {
  AddTodoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '新 Todo 的内容',
            ),
          ),
        ),
        TextButton(
            onPressed: () {
              debugPrint("添加按钮按下");
            },
            child: Text(
              "添加",
              style: TextStyle(fontSize: 24),
            ))
      ],
    );
  }
}

class TodoWidget extends StatelessWidget {
  final String content;

  TodoWidget({super.key, this.content = ""});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle_outlined,
          size: 36,
        ),
        Text(
          content,
          style: TextStyle(fontSize: 36),
        ),
      ],
    );
  }
}
