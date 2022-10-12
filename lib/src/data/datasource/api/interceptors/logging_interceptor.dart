import 'dart:async';

import '../../../../foundation/helper/helper.dart';
import '../client/client.dart';

class LoggingInterceptor with Interceptor {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    logI(request.toString());
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
    BaseResponseCallback? retry,
  }) async {
    if (response is Response) {
      logI('${response.request} ${response.statusCode}\n${response.body}');
      return response;
    }
    logI('${response.request} ${response.statusCode} ${response.toString()}');
    return response;
  }
}
