class PostResponse {
  final int userId;
  final int id;
  final String title;
  final String body;

  const PostResponse({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) => PostResponse(
        userId: json["userId"] as int,
        id: json["id"] as int,
        title: json["title"] as String,
        body: json["body"] as String,
      );
}
