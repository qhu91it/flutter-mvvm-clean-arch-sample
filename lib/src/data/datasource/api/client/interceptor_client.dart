import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';

import 'interceptor.dart';
import 'request_ext.dart';
import 'response_ext.dart';

class InterceptorClient extends BaseClient {
  InterceptorClient({List<Interceptor> interceptors = const []})
      : _interceptors = interceptors;

  final _client = Client();
  final List<Interceptor> _interceptors;

  /// Number retry
  int _retryCount = 0;

  /// Retry callback function
  BaseResponseCallback? _retry(BaseRequest request) => (max) async {
        var resp = await _attemptRequest(request);
        _retryCount += 1;
        resp = await _interceptResponse(
          resp,
          _retryCount >= max ? null : _retry(request),
        );
        _retryCount = 0;
        return resp;
      };

  @override
  Future<Response> head(
    Uri url, {
    Map<String, String>? headers,
  }) async =>
      (await _sendUnstreamed('HEAD', url, headers)) as Response;

  @override
  Future<Response> get(
    Uri url, {
    Map<String, String>? headers,
    Map<String, dynamic>? params,
  }) async =>
      (await _sendUnstreamed('GET', url, headers, params)) as Response;

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Map<String, dynamic>? params,
    Object? body,
    Encoding? encoding,
  }) async =>
      (await _sendUnstreamed('POST', url, headers, body, encoding)) as Response;

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Map<String, dynamic>? params,
    Object? body,
    Encoding? encoding,
  }) async =>
      (await _sendUnstreamed('PUT', url, headers, body, encoding)) as Response;

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Map<String, dynamic>? params,
    Object? body,
    Encoding? encoding,
  }) async =>
      (await _sendUnstreamed('PATCH', url, headers, body, encoding))
          as Response;

  @override
  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Map<String, dynamic>? params,
    Object? body,
    Encoding? encoding,
  }) async =>
      (await _sendUnstreamed('DELETE', url, headers, body, encoding))
          as Response;

  @override
  Future<String> read(
    Uri url, {
    Map<String, String>? headers,
    Map<String, dynamic>? params,
  }) {
    return get(url, headers: headers, params: params).then((response) {
      _checkResponseSuccess(url, response);
      return response.body;
    });
  }

  @override
  Future<Uint8List> readBytes(
    Uri url, {
    Map<String, String>? headers,
    Map<String, dynamic>? params,
  }) {
    return get(url, headers: headers, params: params).then((response) {
      _checkResponseSuccess(url, response);
      return response.bodyBytes;
    });
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final response = await _attemptRequest(request);

    final interceptedResponse = await _interceptResponse(
      response,
      _retry(request),
    );
    return interceptedResponse as StreamedResponse;
  }

  Future<BaseResponse> _sendUnstreamed(
    String method,
    Uri url,
    Map<String, String>? headers, [
    Object? body,
    Encoding? encoding,
  ]) async {
    var request = Request(method, url);

    if (headers != null) request.headers.addAll(headers);
    if (encoding != null) request.encoding = encoding;
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = body.cast<int>();
      } else if (body is Map) {
        request.bodyFields = body.cast<String, String>();
      } else {
        throw ArgumentError('Invalid request body "$body".');
      }
    }

    var response = await _attemptRequest(request);
    // Intercept response
    response = await _interceptResponse(
      response,
      _retry(request),
    );
    return response;
  }

  void _checkResponseSuccess(Uri url, Response response) {
    if (response.statusCode < 400) return;
    var message = 'Request to $url failed with status ${response.statusCode}';
    if (response.reasonPhrase != null) {
      message = '$message: ${response.reasonPhrase}';
    }
    throw ClientException('$message.', url);
  }

  /// Attempts to perform the request and intercept the data
  /// of the response
  Future<BaseResponse> _attemptRequest(BaseRequest request) async {
    BaseResponse response;
    try {
      // Intercept request
      final interceptedRequest = await _interceptRequest(request);
      var stream = await _client.send(interceptedRequest);
      response =
          request is Request ? await Response.fromStream(stream) : stream;
    } on Exception {
      rethrow;
    }
    return response;
  }

  /// This internal function intercepts the request.
  Future<BaseRequest> _interceptRequest(BaseRequest request) async {
    BaseRequest interceptedRequest = request.copyWith();
    for (final interceptor in _interceptors) {
      if (await interceptor.shouldInterceptRequest()) {
        interceptedRequest = await interceptor.interceptRequest(
          request: interceptedRequest,
        );
      }
    }

    return interceptedRequest;
  }

  /// This internal function intercepts the response.
  /// It's check can retry before intercepts the response.
  Future<BaseResponse> _interceptResponse(BaseResponse response,
      [BaseResponseCallback? retry]) async {
    BaseResponse interceptedResponse = response.copyWith();
    for (final interceptor in _interceptors) {
      if (await interceptor.shouldInterceptResponse()) {
        final canRetry = await interceptor.shouldAttemptRetryOnResponse(
            response: interceptedResponse);
        interceptedResponse = await interceptor.interceptResponse(
          response: interceptedResponse,
          retry: canRetry ? retry : null,
        );
      }
    }

    return interceptedResponse;
  }

  @override
  void close() {
    _client.close();
    super.close();
  }
}
