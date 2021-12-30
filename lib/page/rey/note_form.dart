import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  final String? title;
  final String? message;

  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedMessage;

  const NoteFormWidget({
    Key? key,
    this.title = '',
    this.message = '',
    required this.onChangedTitle,
    required this.onChangedMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              SizedBox(height: 8),
              buildMessage(),
              SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: TextStyle(
          color: Colors.blue.shade700,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.blue.shade700),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildMessage() => TextFormField(
        maxLines: 5,
        initialValue: message,
        style: TextStyle(color: Colors.blue.shade400, fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Colors.blue.shade400),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The message cannot be empty'
            : null,
        onChanged: onChangedMessage,
      );
}
