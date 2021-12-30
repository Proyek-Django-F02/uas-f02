import 'package:flutter/material.dart';
import 'package:uas_f02/page/shabrina/todo_model.dart';
import 'package:uas_f02/page/shabrina/task.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScreenArguments {
  final int taskId;
  static const route = '/add';
  ScreenArguments(this.taskId);
}

class TodoFormEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Task"),
      ),
      body: TodoForm(),
    );
  }
}

class TodoForm extends StatefulWidget {
  @override
  TodoFormState createState() {
    return TodoFormState();
  }
}

class TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  var editableTask;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final deadlineController = TextEditingController();
  bool isEditForm = false;
  final todoModel;

  TodoFormState({this.todoModel});

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  void createTask(addTodo) {
    var task = new Task(
      title: titleController.text,
      desc: descriptionController.text,
      deadline: deadlineController.text,
    );
    addTodo(task);
    Navigator.pop(context);
  }

  void loadTaskForEdit(BuildContext context) {
    final ScreenArguments arguments = ModalRoute.of(context)?.settings.arguments as ScreenArguments;
    if (arguments != null && arguments.taskId != null) {
      isEditForm = true;

      editableTask = new TodoModel().read(arguments.taskId);
      titleController.text = editableTask.title;
      descriptionController.text = editableTask.desc;
      deadlineController.text = editableTask.deadline;
    }
  }

  void editTask(Function editTask) {
    editTask(editableTask.id, titleController.text, descriptionController.text, deadlineController.text);
    Navigator.pop(context);
  }
  void deleteTask(Function deleteTask) {
    deleteTask(editableTask.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    loadTaskForEdit(context);
    return Material(
      child: Form(
          key: _formKey,
          child: Consumer<TodoModel> (
            builder: (context, todoModel, child) => Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Add New Task",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.task),
                        labelText: "Title",
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0))
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.description),
                      labelText: "Description",
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0))
                    ),
                  ),
                ),
                // https://www.fluttercampus.com/guide/39/how-to-show-date-picker-on-textfield-tap-and-get-formatted-date/
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: deadlineController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: "Enter date",
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0))
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2110)
                      );
                      if (pickedDate != null) {
                        print(pickedDate);
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate);

                        setState(() {
                          deadlineController.text = formattedDate;
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),
                ),
                RaisedButton(
                  child: Text(
                    isEditForm ? "Update" : "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () => {
                    isEditForm ? editTask(todoModel.updateTask) : createTask(todoModel.add)
                  },
                ),
                isEditForm ? RaisedButton(
                  onPressed: () => deleteTask(todoModel.delete),
                )
                    : new Container()
              ],
            ),
          )
      ),
    );
  }
}