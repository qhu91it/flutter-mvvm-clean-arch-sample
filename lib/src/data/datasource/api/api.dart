import 'dart:async';
import 'dart:convert';

import '../../../foundation/common/common.dart';
import '../../models/models.dart';
import 'client/client.dart';
import 'interceptors/interceptors.dart';

enum ApiMethod { get, post }

abstract class Api<T> {
  late List<Interceptor> interceptors;
  late String scheme;
  late String host;
  late String version;
  late String path;
  late ApiMethod method;
  String fullUrl();
  Map<String, dynamic> parameters();
  Map<String, String> headers();

  Api build(ApiBaseParameter parameter);

  Future<T> convertObject(String responseBody);
  Future<ApiBaseResponse<T>> exe();
}

class BaseApiImpl<T> implements Api {
  final List<Interceptor> defaultInterceptors = [
    LoggingInterceptor(),
    RetryInterceptor(),
  ];

  @override
  List<Interceptor> interceptors = [];

  @override
  String scheme = 'https';

  @override
  String host = Constants.of().jsonplaceholderHost;

  @override
  String version = '';

  @override
  late String path;

  @override
  ApiMethod method = ApiMethod.get;

  @override
  String fullUrl() => "$scheme://$host$version$path";

  @override
  Map<String, String> headers() => {
        "Accept-Encoding": "gzip, deflate",
        "Accept": "application/json",
        "Content-type": "application/json; charset=UTF-8",
      };

  @override
  Map<String, dynamic> parameters() => {};

  @override
  Api build(ApiBaseParameter parameter) {
    throw UnimplementedError();
  }

  @override
  Future<T> convertObject(String responseBody) {
    throw UnimplementedError();
  }

  @override
  Future<ApiBaseResponse<T>> exe() async {
    final comp = Completer<ApiBaseResponse<T>>();
    final client = InterceptorClient(
        interceptors:
            interceptors.isEmpty ? defaultInterceptors : interceptors);
    Response resp;
    switch (method) {
      case ApiMethod.get:
        final uri = Uri(
          scheme: scheme,
          host: host,
          path: "$version$path",
          queryParameters: parameters(),
        );
        resp = await client.get(uri, headers: headers());
        break;
      case ApiMethod.post:
        final uri = Uri.parse(fullUrl());
        final body = jsonEncode(parameters());
        resp = await client.post(
          uri,
          headers: headers(),
          body: body,
          encoding: Encoding.getByName('utf-8'),
        );
        break;
      default:
        throw UnimplementedError();
    }
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      final result = ApiBaseResponse<T>(
        error: ApiErrorResponse(
          code: "${resp.statusCode}",
          message: resp.reasonPhrase ?? resp.body,
        ),
      );
      comp.complete(result);
    } else {
      final data = await convertObject(resp.body);
      final result = ApiBaseResponse<T>(data: data);
      comp.complete(result);
    }
    return comp.future;
  }
}
