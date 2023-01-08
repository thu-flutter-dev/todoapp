class Todo {
  int number = 0;
  String content = "";

  Todo(this.number, this.content);
}

class TodoList {
  List<Todo> data = [];
  int count = 0;

  TodoList(List<String> contents) {
    List<Todo> data = [];
    for (int i = 0; i < contents.length; i++) {
      data.add(Todo(i, contents[i]));
    }
    this.data = data;
  }

  // void insert(String content) {
  //   data.add(Todo(count, content));
  //   count += 1;
  // }

  // void delete(int number) {
  //   data.removeWhere((todo) {
  //     return todo.number == number;
  //   });
  // }
}

// TodoList todoList = TodoList([
//   "Todo0",
//   "Todo1",
//   "Todo2",
//   "Todo3",
//   "Todo4",
//   "Todo5",
//   "Todo6",
//   "Todo7",
//   "Todo8",
//   "Todo9",
//   "Todo10",
//   "Todo11",
//   "Todo12",
//   "Todo13",
//   "Todo14",
//   "Todo15",
//   "Todo16",
//   "Todo17",
//   "Todo18",
//   "Todo19",
//   "Todo20",
//   "Todo21",
//   "Todo22",
//   "Todo23",
//   "Todo24",
// ]);
