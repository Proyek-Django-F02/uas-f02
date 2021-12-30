import 'dart:convert';

class Note {
  final String message;
  final int id;
  final String title;
  final String timestamp;

  Note({
    required this.message,
    required this.id,
    required this.title,
    required this.timestamp,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      message: json['message'],
      id: json['id'],
      title: json['title'],
      timestamp: json['timestamp'],
    );
  }

  Note copy({
    int? id,
    String? title,
    String? message,
    String? timestamp,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        message: message ?? this.message,
        timestamp: timestamp ?? this.timestamp,
      );
}

class notesObj {
  String timestamp;
  String title;
  String message;

  notesObj({
    required this.title,
    required this.timestamp,
    required this.message,
  });
}
