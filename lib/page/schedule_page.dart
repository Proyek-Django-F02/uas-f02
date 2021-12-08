import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  final String name;
  final String urlImage;
  final String email;

  const SchedulePage({
    Key? key,
    required this.name,
    required this.email,
    required this.urlImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Schedule"),
          centerTitle: true,
        ),
      );
}
