class Todo {
  int number = 0;
  String content = "";

  Todo(this.number, this.content);
}

class TodoList {
  List<Todo> data = [];
  int count = 0;

  TodoList() {
    this.data = [Todo(0, "完成课堂作业"), Todo(1, "看课件预习")];
  }

  void insert(String content) {
    data.add(Todo(count, content));
    count += 1;
  }

  void delete(int number) {
    data.removeWhere((todo) {
      return todo.number == number;
    });
  }

  void display() {
    for (final todo in data) {
      print("${todo.number} ${todo.content}");
    }
  }
}
