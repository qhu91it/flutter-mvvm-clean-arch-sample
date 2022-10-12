import '../../data/models/models.dart';

abstract class PostRepository {
  Future<List<PostResponse>> getAll();
  Future<PostResponse?> add(ApiAddPostParameter parameter);
}
