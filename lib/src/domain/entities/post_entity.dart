import 'package:equatable/equatable.dart';

import '../../data/models/models.dart';

class PostEntity implements Equatable {
  final int userId;
  final int id;
  final String title;
  final String body;

  const PostEntity({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory PostEntity.fromResponse(PostResponse resp) => PostEntity(
        userId: resp.userId,
        id: resp.id,
        title: resp.title,
        body: resp.body,
      );

  @override
  List<Object?> get props => [userId, id, title, body];

  @override
  bool? get stringify => true;
}
