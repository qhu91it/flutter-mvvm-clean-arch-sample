import 'dart:async';
import 'dart:convert';

import '../../models/models.dart';
import 'api.dart';
import 'client/client.dart';
import 'interceptors/interceptors.dart';

class PostPostApiImpl with BaseApiImpl<PostResponse> {
  ApiAddPostParameter? parameter;

  @override
  List<Interceptor> get interceptors => [
        ...defaultInterceptors,
        PrintParamInterceptor(),
      ];

  @override
  String get path => '/posts';

  @override
  ApiMethod get method => ApiMethod.post;

  @override
  Map<String, dynamic> parameters() => {
        "userId": parameter?.userId,
        "title": parameter?.title,
        "body": parameter?.body,
      };

  @override
  Api build(ApiBaseParameter parameter) {
    this.parameter = parameter as ApiAddPostParameter;
    return this;
  }

  @override
  Future<PostResponse> convertObject(String responseBody) {
    final comp = Completer<PostResponse>();
    final Map<String, dynamic> parsed = jsonDecode(responseBody);
    final resp = PostResponse.fromJson(parsed);
    comp.complete(resp);
    return comp.future;
  }
}
