import '../../data/models/models.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

abstract class PostList {
  late List<PostEntity> posts;
  Future<void> load();
  Future<bool> add(String title, String body);
}

class PostListImpl implements PostList {
  final PostRepository _postRepo;

  PostListImpl({required PostRepository postRepo}) : _postRepo = postRepo;

  @override
  List<PostEntity> posts = [];

  @override
  Future<void> load() async {
    final remotePosts = await _postRepo.getAll();
    posts = remotePosts.map((e) => PostEntity.fromResponse(e)).toList();
  }

  @override
  Future<bool> add(String title, String body) async {
    final post = await _postRepo.add(ApiAddPostParameter(
      userId: 1,
      title: title,
      body: body,
    ));
    if (post == null) {
      return false;
    }
    posts = [
      PostEntity.fromResponse(post),
      ...posts,
    ];
    return true;
  }
}
