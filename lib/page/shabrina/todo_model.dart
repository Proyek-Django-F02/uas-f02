import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:uas_f02/page/shabrina/task.dart';

class TodoModel extends ChangeNotifier {
  List<Task> _todos = [];

  UnmodifiableListView<Task> get todos => UnmodifiableListView(_todos);

  void add(Task task) {
    task.id = todos.last.id + 1;
    _todos.add(task);
    notifyListeners();
  }

  void toggleChecklist(int id) {
    var index = _todos.indexWhere((element) => element.id == id);
    _todos[index].checklist = !_todos[index].checklist;
    notifyListeners();
  }

  Task read(int id) {
    return _todos.firstWhere((element) => element.id == id);
  }

  void updateTask(int id, String newTitle, String newDescription, String newDeadline) {
    var task = _todos.firstWhere((task) => task.id == id);
    task.title = newTitle;
    task.desc = newDescription;
    task.deadline = newDeadline;
    notifyListeners();
  }

  void delete(int id) {
    _todos.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}