class CommentEntity {
  int id;
  String title;
  String content;
  String date;
  String email;

  CommentEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        date = json['date'],
        email = json['author']['email'];
}
