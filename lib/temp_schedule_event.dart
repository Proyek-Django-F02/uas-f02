class Event {

  final String title;
  // final TimeOfDay time;
  String desc = '';
  String type = 'General';

  Event({required this.title, required this.desc, required this.type
    // required this.time, required this.description, required this.type
  });

  @override
  String toString() => title;
}