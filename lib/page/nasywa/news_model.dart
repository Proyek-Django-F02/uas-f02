class News {
  final String title;
  final String desc;

  News._({required this.title, required this.desc});

  factory News.fromJson(Map<String, dynamic> json) {
    return new News._(
      title: json['title'],
      desc: json['desc'],
    );
  }
}