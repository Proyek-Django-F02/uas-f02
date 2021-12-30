import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:uas_f02/page/rey/note_add_edit.dart';
import 'package:uas_f02/page/rey/note_card_widget.dart';
import 'package:uas_f02/page/rey/note_detail.dart';
import 'package:uas_f02/page/rey/note_model.dart';
import 'package:uas_f02/page/rey/note_repo.dart';

class Notes extends StatefulWidget {
  final String name;
  final String urlImage;
  final String email;

  const Notes({
    Key? key,
    required this.name,
    required this.email,
    required this.urlImage,
  }) : super(key: key);

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<Notes> {
  late String name;
  late String urlImage;
  late String email;
  List<Note> notes = [];
  Repo repo = Repo();
  bool isLoading = false;

  getData(String name) async {
    setState(() => isLoading = true);
    notes = await repo.getAllData(name);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    name = widget.name;
    urlImage = widget.urlImage;
    email = widget.email;
    getData(name);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('notes'),
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : notes.isEmpty
                  ? Text(
                      'No Notes',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            child: Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => AddEditNotePage(name: name)),
              );

              getData(name);
            }));
  }

  Widget buildNotes() => StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(8),
      itemCount: notes.length,
      staggeredTileBuilder: (index) => StaggeredTile.fit(2),
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemBuilder: (context, index) {
        final note = notes[index];

        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => noteDetail(id: note.id, name: name),
            ));

            getData(name);
          },
          child: NoteCardWidget(note: note, index: index),
        );
      });
}
