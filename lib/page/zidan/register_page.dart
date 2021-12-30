import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  late String _name;
  late String _email;
  late String _password;
  late String _message;
  late bool _success;

  void initState() {
    super.initState();
    setState(() {
      _message = '';
      _success = false;
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

  Widget _buildEmail() {
    return TextFormField(
      decoration: new InputDecoration(
        labelText: "Email",
        icon: Icon(Icons.mail),
        border:
            OutlineInputBorder(borderRadius: new BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Email is Required';
        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }
        return null;
      },
      onSaved: (value) {
        _email = value!;
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

  Widget _buildConfirmPass() {
    return TextFormField(
      controller: _confirmPass,
      obscureText: true,
      decoration: new InputDecoration(
        labelText: "Konfirmasi Password",
        icon: Icon(Icons.security),
        border:
            OutlineInputBorder(borderRadius: new BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Konfirmasi Password tidak boleh kosong';
        if (value != _pass.text) return 'Not Match';
        return null;
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
                          "Registrasi Pengguna Baru",
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildUserName()),
                Padding(
                    padding: const EdgeInsets.all(8.0), child: _buildEmail()),
                Padding(
                    padding: const EdgeInsets.all(8.0), child: _buildPass()),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildConfirmPass()),
                RaisedButton(
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      print(_name);
                      print(_email);
                      print(_password);
                      final response = await http.post(
                          Uri.parse(
                              "http://django-f02.herokuapp.com/user/flutter/register"),
                          headers: <String, String>{
                            'Content-Type': 'application/json;charset=UTF-8',
                          },
                          body: jsonEncode(<String, String>{
                            // print(response.headers.toString());
                            'email': _email,
                            'username': _name,
                            'password': _password
                          }));
                      final Map parsed = json.decode(response.body);
                      if (response.statusCode == 200) {
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
