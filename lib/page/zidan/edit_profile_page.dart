import 'dart:convert';
import 'package:uas_f02/widget/zidan/DatePicker.dart' as datepicker;
import 'package:flutter/material.dart';
// import 'package:';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Profile> fetchProfile(String username) async {
  final response = await http
      .get(Uri.parse('http://10.0.2.2:8000/user/flutter/profile/' + username));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Profile.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Profile');
  }
}

class Profile {
  final String username;
  final String email;
  final DateTime bod;
  final String bio;

  Profile({
    required this.username,
    required this.email,
    required this.bod,
    required this.bio,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    DateTime res;
    try {
      res = DateTime.parse(json['bod']);
    } catch (e) {
      res = DateTime.now();
    }
    return Profile(
        username: json['username'],
        email: json['email'],
        bod: res,
        bio: json['bio']);
  }
}

class EditProfile extends StatefulWidget {
  final String name;
  final String email;
  const EditProfile({
    Key? key,
    required this.name,
    required this.email,
  }) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late String _description;
  late DateTime _birthday;

  late String name;
  late String email;
  late Future<Profile> futureProfile;
  late RestorableDateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    email = widget.email;
    futureProfile = fetchProfile(name).then((value) {
      try {
        _selectedDate = RestorableDateTime(value.bod);
      } catch (e) {
        _selectedDate = RestorableDateTime(DateTime.now());
      }
      _description = value.bio;
      return value;
    });
  }

  Widget _buildBio(String initVal) {
    return TextFormField(
      initialValue: initVal,
      decoration: new InputDecoration(
        hintText: "contoh: Hai! saya suka kucing",
        labelText: "Deskripsi diri",
        border:
            OutlineInputBorder(borderRadius: new BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Deskripsi tidak boleh kosong';
        }
        return null;
      },
      onChanged: (x) {
        setState(() {
          _description = x;
        });
      },
    );
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        _birthday = newSelectedDate;
      });
    }
  }

  Widget _buildBirthday(DateTime newSelectedDate) {
    return datepicker.DatePicker(
      select: _selectDate,
      restorationId: 'main',
      selectedDate: _selectedDate,
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Profile"),
          centerTitle: true,
        ),
        body: FutureBuilder<Profile>(
            future: futureProfile,
            builder: (context, AsyncSnapshot<Profile> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Form(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                "Edit Your Profile",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _buildBirthday(snapshot.data!.bod)),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _buildBio(snapshot.data!.bio)),
                              RaisedButton(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.blue,
                                onPressed: () async {
                                  print(_selectedDate.value);
                                  final response = await http.post(
                                      Uri.parse(
                                          "http://10.0.2.2:8000/user/flutter/edit-profile"),
                                      headers: <String, String>{
                                        'Content-Type':
                                            'application/json;charset=UTF-8',
                                      },
                                      body: jsonEncode(<String, String>{
                                        'username': name,
                                        'bio': _description,
                                        'bod': _selectedDate.value.toString()
                                      }));
                                  final Map parsed = json.decode(response.body);
                                  String res = "Tidak berhasil";
                                  if (response.statusCode == 200) {
                                    res = "Berhasil";
                                  }
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(res),
                                  ));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              }
            }));
  }
}
