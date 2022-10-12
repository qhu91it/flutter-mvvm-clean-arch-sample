import 'dart:async';
import 'dart:convert';

import '../../models/models.dart';
import 'api.dart';

class GetPostsApi extends BaseApiImpl<List<PostResponse>> {
  @override
  String get path => '/posts';

  @override
  Future<List<PostResponse>> convertObject(String responseBody) {
    final comp = Completer<List<PostResponse>>();
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    final resp = parsed
        .map<PostResponse>((json) => PostResponse.fromJson(json))
        .toList();
    comp.complete(resp);
    return comp.future;
  }
}
