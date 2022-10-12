import '../../domain/repositories/repositories.dart';
import '../datasource/api/api.dart';
import '../models/models.dart';

class PostRepositoryImpl extends PostRepository {
  final Api getPostsApi;
  final Api postPostApi;

  PostRepositoryImpl({
    required this.getPostsApi,
    required this.postPostApi,
  });

  @override
  Future<PostResponse?> add(ApiAddPostParameter parameter) async {
    final post = await postPostApi.build(parameter).exe();
    return post.data;
  }

  @override
  Future<List<PostResponse>> getAll() async {
    final posts = await getPostsApi.exe();
    return posts.data ?? [];
  }
}
