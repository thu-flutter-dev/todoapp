import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model.dart';

void main() async {
  if (kDebugMode) {
    runApp(MyApp(defaultTodos: debugTodos, database: null));
  } else {
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      // Avoid errors caused by flutter upgrade.
      // Importing 'package:flutter/widgets.dart' is required.
      WidgetsFlutterBinding.ensureInitialized();

      // 创建并连接数据库
      // Open the database and store the reference.
      final database = openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), databaseName),
        // When the database is first created, create a table to store todos.
        onCreate: (db, version) {
          // Run the CREATE TABLE statement on the database.
          return db.execute(
            "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, content TEXT)",
          );
        },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,
      );

      // 读取用户上次使用存储的数据
      // Get a reference to the database.
      final db = await database;
      // Query the table for all The Todos.
      final List<Map<String, dynamic>> maps = await db.query(tableName);
      // Convert the List<Map<String, dynamic> into a List<Todo>.
      var defaultTodos = List.generate(maps.length, (i) {
        return Todo(maps[i]['id'], maps[i]['content']);
      });
      runApp(MyApp(defaultTodos: defaultTodos, database: database));
    } else {
      runApp(MyApp(defaultTodos: [], database: null));
    }
  }
}

class MyApp extends StatelessWidget {
  final List<Todo> defaultTodos;
  final Future<Database>? database;
  MyApp({super.key, required this.defaultTodos, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TodoApp",
      home: Scaffold(
          body: ChangeNotifierProvider(
        create: (context) =>
            TodoListModel(todos: defaultTodos, database: database),
        child: ContentWidget(),
      )),
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
          child: Consumer<TodoListModel>(builder: (context, model, child) {
            if (model.todos.isNotEmpty) {
              return ListView(
                children:
                    model.todos.map((todo) => TodoWidget(todo: todo)).toList(),
              );
            } else {
              return Center(
                  child: Text(
                "欢迎使用 TodoApp\n你可以在下方输入新的 Todo",
                style: TextStyle(fontSize: 36),
                textAlign: TextAlign.center,
              ));
            }
          }),
        ),
        AddTodoWidget()
      ],
    );
  }
}

class TodoWidget extends StatelessWidget {
  final Todo todo;

  TodoWidget({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Consumer<TodoListModel>(builder: (context, model, child) {
          return TextButton(
              onPressed: () {
                model.delete(todo.id);
              },
              child: Icon(
                Icons.circle_outlined,
                size: 36,
              ));
        }),
        Text(
          todo.content,
          style: TextStyle(fontSize: 36),
        ),
      ],
    );
  }
}

class AddTodoWidget extends StatefulWidget {
  AddTodoWidget({super.key});

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
        Consumer<TodoListModel>(builder: (context, model, child) {
          return TextButton(
              onPressed: () {
                debugPrint("添加按钮按下 内容为${textFieldController.text}");
                model.insert(textFieldController.text);
                textFieldController.text = "";
              },
              child: Text(
                "添加",
                style: TextStyle(fontSize: 24),
              ));
        })
      ],
    );
  }
}
