import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnonymousPage extends StatefulWidget {
  final String name;
  final String urlImage;
  final String email;

  const AnonymousPage({
    Key? key,
    required this.name,
    required this.email,
    required this.urlImage,
  }) : super(key: key);

  @override
  AnonymousPageState createState() => AnonymousPageState();
}

class AnonymousPageState extends State<AnonymousPage> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;

  // refer AnonymousPage variables as widget.var
  List data = [];
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var messageListA = data.map((var dataList) {
      // map every messages to anonymsgItem
      return AnonymsgItem(
          question: dataList["name"], answer: dataList["email"]);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Anonymous Messages"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.green[300],
          padding: const EdgeInsets.all(5.0), // pads outside of question box
          child: ListView.builder(
              itemCount: data.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return messageListA[index];
              }),
        ),
      ),
    );
  }
}

class AnonymsgItem extends StatefulWidget {
  AnonymsgItem({Key? key, required this.question, required this.answer})
      : super(key: key);
  String question;
  String answer;

  @override
  AnonymsgItemState createState() => AnonymsgItemState();
}

class AnonymsgItemState extends State<AnonymsgItem> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: const Icon(Icons.question_answer)),
            title: Text(widget.question),
            subtitle: Text(widget.answer),
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    controller: myController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Submitted Answer")),
                        );
                        print(myController.text);

                        setState(() {
                          widget.answer = myController.text;
                        });
                      }
                    },
                    child: const Text('Answer'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              // The validator receives the text that the user has entered.
              controller: myController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(myController.text)),
                    );
                  }
                },
                child: const Text('Answer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
