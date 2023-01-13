import 'package:flutter/material.dart';

class Todo {
  int number = 0;
  String content = "";

  Todo(this.number, this.content);
}

class TodoListModel extends ChangeNotifier {
  // source of states
  List<Todo> data = [];
  int count = 0;

  TodoListModel(List<String> contents) {
    List<Todo> data = [];
    for (int i = 0; i < contents.length; i++) {
      data.add(Todo(i, contents[i]));
    }
    this.data = data;
  }

  void insert(String content) {
    data.add(Todo(count, content));
    count += 1;
    notifyListeners(); // re-build widgets
  }

  void delete(int number) {
    data.removeWhere((todo) {
      return todo.number == number;
    });
    notifyListeners(); // re-build widgets
  }
}

List<String> defaultTodoContents = List.generate(25, (i) => "Todo $i");
