import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas_f02/widget/button_widget.dart';

Future<Profile> fetchProfile(String username) async {
  final response = await http
      .get(Uri.parse('http://localhost:8000/user/flutter/profile/' + username));

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
    return Profile(
        username: json['username'],
        email: json['email'],
        bod: json['bod'],
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
    // TODO: implement initState
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
              judul + " : ",
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

  Widget buildContent() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.mode_edit_outline, size: 28),
          SizedBox(width: 16),
          Text(
            "Edit Profile",
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
        ],
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
                        buildField("Nama", name),
                        buildField("Email", email),
                        buildField("Birthday", snapshot.data!.bod),
                        buildField("Deskripsi diri", snapshot.data!.bio),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 60),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(50),
                            ),
                            child: buildContent(),
                            onPressed: () {},
                          ),
                        ),
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
