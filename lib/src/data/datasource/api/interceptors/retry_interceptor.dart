import 'dart:async';
import 'dart:math';

import '../../../../foundation/helper/helper.dart';
import '../client/client.dart';

class RetryInterceptor with Interceptor {
  /// Retry two times, not count the first one
  final _maxRetryAttempts = 2;

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async =>
      request;

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
    BaseResponseCallback? retry,
  }) async {
    if (retry != null) {
      logI('Retry ${response.request}');
      return await retry(_maxRetryAttempts);
    }
    return response;
  }

  @override
  Future<bool> shouldAttemptRetryOnResponse({
    required BaseResponse response,
  }) async {
    // Condition check need retry or not
    if (response.statusCode == 201) {
      Random r = Random();
      bool result = r.nextDouble() <= 0.3;
      return result;
    }
    return false;
  }
}
