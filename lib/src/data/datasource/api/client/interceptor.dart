import 'package:http/http.dart';

typedef BaseResponseCallback = Future<BaseResponse> Function(int max);

abstract class Interceptor {
  Future<bool> shouldInterceptRequest() async => true;

  Future<BaseRequest> interceptRequest({required BaseRequest request});

  Future<bool> shouldInterceptResponse() async => true;

  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
    BaseResponseCallback? retry,
  });

  Future<bool> shouldAttemptRetryOnResponse({
    required BaseResponse response,
  }) async =>
      false;
}
