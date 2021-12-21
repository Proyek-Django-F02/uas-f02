import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late String _name;
  late String _password;
  late Future<String> _email;
  late Future<String> _username;
  late String _message;
  late bool _success;

  void initState() {
    super.initState();
    setState(() {
      _message = "";
      _success = false;
    });
  }

  Future<void> _loginUser(String username, String email) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _email = prefs.setString('email', email).then((bool success) {
        return email;
      });
      _username = prefs.setString('username', username).then((bool success) {
        return username;
      });
    });
  }

  Widget _buildUserName() {
    return TextFormField(
      decoration: new InputDecoration(
        hintText: "contoh: Susilo Bambang",
        labelText: "Nama Lengkap",
        icon: Icon(Icons.people),
        border:
            OutlineInputBorder(borderRadius: new BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Nama tidak boleh kosong';
        }
        return null;
      },
      onSaved: (value) {
        _name = value!;
      },
    );
  }

  Widget _buildPass() {
    return TextFormField(
      controller: _pass,
      obscureText: true,
      decoration: new InputDecoration(
        labelText: "Password",
        icon: Icon(Icons.security),
        border:
            OutlineInputBorder(borderRadius: new BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Password tidak boleh kosong';
        }
        return null;
      },
      onSaved: (value) {
        _password = value!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Be Productive"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                _message != ''
                    ? AlertDialog(
                        title: const Text('Perhatian, pengguna'),
                        content: Text(_message),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              if (_success) {
                                Navigator.pop(context, 'OK');
                              }
                            },
                            child: _success
                                ? Text("OK")
                                : SizedBox(
                                    height: 0,
                                  ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildUserName()),
                Padding(
                    padding: const EdgeInsets.all(8.0), child: _buildPass()),
                RaisedButton(
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      print(_name+"  "+_password);
                      final response = await http.post(
                          Uri.parse("http://localhost:8000/user/flutter/login"),
                          headers: <String, String>{
                            'Content-Type': 'application/json;charset=UTF-8',
                          },
                          body: jsonEncode(<String, String>{
                            // print(response.headers.toString());
                            'username': _name,
                            'password': _password
                          }));
                      final Map parsed = json.decode(response.body);
                      if (response.statusCode == 200) {
                        _loginUser(parsed['username'], parsed['email']);
                        setState(() {
                          _success = true;
                        });
                      }
                      setState(() {
                        _message = parsed['message'];
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
