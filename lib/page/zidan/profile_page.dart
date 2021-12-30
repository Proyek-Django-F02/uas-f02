import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas_f02/widget/button_widget.dart';
import 'package:uas_f02/page/zidan/edit_profile_page.dart';

Future<Profile> fetchProfile(String username) async {
  final response = await http
      .get(Uri.parse('http://django-f02.herokuapp.com/user/flutter/profile/' + username));

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
  final String bod;
  final String bio;

  Profile({
    required this.username,
    required this.email,
    required this.bod,
    required this.bio,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    String res = "";
    try {
      DateTime x = DateTime.parse(json['bod']);
      res =
          x.day.toString() + "/" + x.month.toString() + "/" + x.year.toString();
    } catch (e) {
      res = "belum diatur";
    }
    return Profile(
        username: json['username'],
        email: json['email'],
        bod: res,
        bio: json['bio']);
  }
}

class ProfilePage extends StatefulWidget {
  final String name;
  final String urlImage;
  final String email;
  const ProfilePage({
    Key? key,
    required this.name,
    required this.email,
    required this.urlImage,
  }) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String name;
  late String urlImage;
  late String email;
  late Future<Profile> futureProfile;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    urlImage = widget.urlImage;
    email = widget.email;
    futureProfile = fetchProfile(name);
  }

  Widget buildField(String judul, String isi) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              judul,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Text(isi, style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 15,
            ),
          ]),
    );
  }

  Widget buildContent() => CircleAvatar(
        radius: 25,
        backgroundColor: Colors.blue.shade400,
        child: Icon(
          Icons.mode_edit_outline,
          color: Colors.white,
          size: 25,
        ),
      );
  @override
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
                    return ListView(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 50),
                          alignment: Alignment.center,
                          child: CircleAvatar(
                              backgroundImage: NetworkImage(urlImage),
                              radius: MediaQuery.of(context).size.width * 0.25),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.15,
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(1),
                                ),
                                child: buildContent(),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                            email: email,
                                            name: name,
                                          )));
                                },
                              ),
                            ),
                          ],
                        ),
                        buildField("Nama", name),
                        buildField("Email", email),
                        buildField("Birthday", snapshot.data!.bod),
                        buildField("Deskripsi diri", snapshot.data!.bio),
                        SizedBox(
                          height: 40,
                        )
                      ],
                    );
                  }
              }
            }));
  }
}
