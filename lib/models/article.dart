class Article {
  int id;
  String title;
  String body;
  String authorName;

  DateTime createdAt;
  DateTime updatedAt;

  Article({
    required this.id,
    required this.title,
    required this.body,
    required this.authorName,
    required this.updatedAt,
    required this.createdAt,
  });

  Article.fromRawData({
    required this.id,
    required this.title,
    required this.body,
    required this.authorName,
    required String createdAt,
    required String updatedAt,
  })  : createdAt = DateTime.parse(createdAt),
        updatedAt = DateTime.parse(updatedAt);
}
