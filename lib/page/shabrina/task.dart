
class Task {
  int id = 0;
  String title;
  String desc;
  bool checklist = false;
  String deadline;

  Task({
    required this.title,
    required this.desc,
    required this.deadline,
  });
}
