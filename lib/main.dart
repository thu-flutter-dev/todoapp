import 'package:flutter/material.dart';
import 'model.dart';

void main() {
  runApp(MyApp(defaultTodoContents: defaultTodoContents));
}

class MyApp extends StatefulWidget {
  final List<String> defaultTodoContents;

  MyApp({super.key, required this.defaultTodoContents});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TodoList todoList;

  @override
  initState() {
    super.initState();

    todoList = TodoList(widget.defaultTodoContents);
  }

  void insert(String content) {
    setState(() {
      todoList.data.add(Todo(todoList.count, content));
    });
    todoList.count += 1;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TodoApp",
      home: Scaffold(
          body: ContentWidget(
        todoList: todoList,
        insert: insert,
      )),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ContentWidget extends StatelessWidget {
  final TodoList todoList;
  final ValueChanged<String> insert;

  ContentWidget({super.key, required this.todoList, required this.insert});

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
        AddTodoWidget(
          todoList: todoList,
          insert: insert,
        )
      ],
    );
  }
}

class AddTodoWidget extends StatefulWidget {
  final TodoList todoList;
  final ValueChanged<String> insert;

  AddTodoWidget({super.key, required this.todoList, required this.insert});

  @override
  State<AddTodoWidget> createState() => _AddTodoWidgetState();
}

class _AddTodoWidgetState extends State<AddTodoWidget> {
  final textFieldController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textFieldController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '新 Todo 的内容',
            ),
          ),
        ),
        TextButton(
            onPressed: () {
              debugPrint("添加按钮按下 内容为${textFieldController.text}");
              widget.insert(textFieldController.text);
              textFieldController.text = "";
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
