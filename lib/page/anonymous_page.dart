import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List> fetchAnonymsgItem(name, urlImage, email) async {
  List<AnonymsgItem> data;

  var response = await http.get(Uri.parse(
      'http://django-f02.herokuapp.com/anonymsg/flutter/list-message/' + name));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    data = (json.decode(response.body) as List)
        .map((i) => AnonymsgItem(
            question: i["anonymous_question"],
            answer: i["anonymous_answer"],
            name: name,
            urlImage: urlImage,
            email: email))
        .toList();
    return data;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load AnonymousMessage');
  }
}

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
  late String name;
  late String urlImage;
  late String email;
  late Future<List> futureAnonymsgItem;

  ScrollController controller = ScrollController();
  bool closeTopContainer = false;

  // refer AnonymousPage variables as widget.var
  @override
  void initState() {
    super.initState();
    name = widget.name;
    urlImage = widget.urlImage;
    email = widget.email;
    futureAnonymsgItem =
        fetchAnonymsgItem(widget.name, widget.urlImage, widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Anonymous Messages"),
          centerTitle: true,
        ),
        body: FutureBuilder<List>(
            future: futureAnonymsgItem,
            builder: (context, AsyncSnapshot<List> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return SafeArea(
                      child: Container(
                        color: Colors.green[300],
                        padding: const EdgeInsets.all(
                            5.0), // pads outside of question box
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return snapshot.data![index];
                            }),
                      ),
                    );
                  }
              }
            }));
  }
}

class AnonymsgItem extends StatefulWidget {
  AnonymsgItem({
    Key? key,
    required this.question,
    required this.answer,
    required this.name,
    required this.urlImage,
    required this.email,
  }) : super(key: key);
  String question;
  String answer;
  String name;
  String urlImage;
  String email;

  @override
  AnonymsgItemState createState() => AnonymsgItemState();
}

class AnonymsgItemState extends State<AnonymsgItem> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  late String _answer;
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
            title: Text(widget.question,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 25),
              title: Text(widget.answer, style: TextStyle(fontSize: 15))),
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
                    onSaved: (value) {
                      _answer = value!;
                    },
                  ),
                ),
                ListTile(
                  leading: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.green[600]),
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Answer submitted")),
                          );
                          _formKey.currentState!.save();
                          print(_answer);
                          print(widget.name);

                          final response = await http.post(
                              Uri.parse(
                                  "http://django-f02.herokuapp.com/anonymsg/flutter/edit-message/"),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json;charset=UTF-8',
                              },
                              body: jsonEncode(<String, String>{
                                // print(response.headers.toString());
                                'username': widget.name,
                                'anonymous_question': widget.question,
                                'anonymous_answer': _answer
                              }));
                          print(response.body);
                          setState(() {
                            widget.answer = _answer;
                          });
                        }
                      },
                      child: const Text('Answer'),
                    ),
                  ),
                  trailing: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red[600]),
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (true) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Message deleted")),
                          );
                          _formKey.currentState!.save();
                          print(_answer);
                          print(widget.name);

                          final response = await http.post(
                              Uri.parse(
                                  "http://django-f02.herokuapp.com/anonymsg/flutter/edit-message/"),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json;charset=UTF-8',
                              },
                              body: jsonEncode(<String, String>{
                                // print(response.headers.toString());
                                'username': widget.name,
                                'anonymous_question': widget.question,
                                'delete': 'true'
                              }));
                          print(response.body);
                          Navigator.pop(context); // pop current page
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AnonymousPage(
                              name: widget.name,
                              email: widget.email,
                              urlImage: widget.urlImage,
                            ),
                          ));
                        }
                      },
                      child: const Text('Delete'),
                    ),
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
