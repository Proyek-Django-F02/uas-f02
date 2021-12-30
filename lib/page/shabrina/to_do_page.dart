import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uas_f02/page/shabrina/todo_form.dart';
import 'package:provider/provider.dart';
import 'package:uas_f02/page/shabrina/todo_model.dart';

class ToDoPage extends StatelessWidget {
  final String name;
  final String urlImage;
  final String email;

  const ToDoPage({
    Key? key,
    required this.name,
    required this.email,
    required this.urlImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue,
      title: Text("To Do List"),
      centerTitle: true,
    ),
    body: TodoList(),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => TodoForm()
      ))
      },
      tooltip: "Add Task",
    ),
  );
}

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoModel>(
        builder: (context, todoModel, child) =>
            ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: todoModel.todos.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Checkbox(
                              value: todoModel.todos[index].checklist,
                              onChanged: (bool? newValue) => {todoModel.toggleChecklist(todoModel.todos[index].id)}
                          ),
                          Text(todoModel.todos[index].title),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => {
                              Navigator.pushNamed(context, ScreenArguments.route, arguments: ScreenArguments(todoModel.todos[index].id))
                            },
                          )
                        ],
                      )
                  );
                }));
  }
}