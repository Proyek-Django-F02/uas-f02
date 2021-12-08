import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Profile"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 50),
              alignment: Alignment.center,
              child: CircleAvatar(
                  backgroundImage: NetworkImage(urlImage),
                  radius: MediaQuery.of(context).size.width * 0.25),
            ),
            Text("Name :", style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.w600),),
            SizedBox(
              height: 10,
            ),
            Text(name,  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 20,
            ),
            Text("Email :",  style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.w600)),
            SizedBox(
              height: 10,
            ),
            Text(email, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      );
}
