import 'dart:async';

import '../../../../foundation/helper/helper.dart';
import '../client/client.dart';

class PrintParamInterceptor with Interceptor {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    if (request is Request) {
      logI('${request.toString()}\n${request.body}');
    } else {
      logI(request.toString());
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
    BaseResponseCallback? retry,
  }) async =>
      response;
}
