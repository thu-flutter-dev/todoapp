import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

const String databaseName = "todo_db";
const String tableName = "todos";
final List<Todo> debugTodos = List.generate(16, (i) => Todo(i, "Todo $i"));

class Todo {
  int id = 0;
  String content = "";

  Todo(this.id, this.content);

  // Convert a Todo into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
    };
  }
}

class TodoListModel extends ChangeNotifier {
  // source of states
  List<Todo> todos;
  int count = 0;

  Future<Database>? database;

  TodoListModel({required this.todos, required this.database}) {
    if (todos.isNotEmpty) {
      count = todos.map((e) => e.id).toList().reduce(max) + 1;
    }
  }

  Future<void> insert(String content) async {
    final todo = Todo(count, content);
    todos.add(todo);
    count += 1;
    notifyListeners(); // re-build widgets

    if (database != null) {
      final db = await database!;

      await db.insert(
        tableName,
        todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> delete(int id) async {
    todos.removeWhere((todo) {
      return todo.id == id;
    });
    notifyListeners(); // re-build widgets

    if (database != null) {
      final db = await database!;

      // Remove the Todo from the database.
      await db.delete(
        tableName,
        // Use a `where` clause to delete a specific todo.
        where: 'id = ?',
        // Pass the Todo's id as a whereArg to prevent SQL injection.
        whereArgs: [id],
      );
    }
  }
}
