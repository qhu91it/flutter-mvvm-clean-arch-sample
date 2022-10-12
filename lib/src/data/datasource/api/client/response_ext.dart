import 'package:http/http.dart';

/// Extends [Response] to provide copied instances.
extension BaseResponseCopyWith on BaseResponse {
  BaseResponse copyWith() {
    if (this is Response) {
      return ResponseCopyWith(this as Response).copyWith();
    } else if (this is StreamedResponse) {
      return StreamedResponseCopyWith(this as StreamedResponse).copyWith();
    }

    throw UnsupportedError(
        'Cannot copy unsupported type of request $runtimeType');
  }
}

/// Extends [Response] to provide copied instances.
extension ResponseCopyWith on Response {
  Response copyWith({
    String? body,
    int? statusCode,
    BaseRequest? request,
    Map<String, String>? headers,
    bool? isRedirect,
    bool? persistentConnection,
    String? reasonPhrase,
  }) =>
      Response(
        body ?? this.body,
        statusCode ?? this.statusCode,
        request: request ?? this.request,
        headers: headers ?? this.headers,
        isRedirect: isRedirect ?? this.isRedirect,
        persistentConnection: persistentConnection ?? this.persistentConnection,
        reasonPhrase: reasonPhrase ?? this.reasonPhrase,
      );
}

/// Extends [StreamedResponse] to provide copied instances.
extension StreamedResponseCopyWith on StreamedResponse {
  StreamedResponse copyWith({
    Stream<List<int>>? stream,
    int? statusCode,
    int? contentLength,
    BaseRequest? request,
    Map<String, String>? headers,
    bool? isRedirect,
    bool? persistentConnection,
    String? reasonPhrase,
  }) =>
      StreamedResponse(
        stream ?? this.stream,
        statusCode ?? this.statusCode,
        contentLength: contentLength ?? this.contentLength,
        request: request ?? this.request,
        headers: headers ?? this.headers,
        isRedirect: isRedirect ?? this.isRedirect,
        persistentConnection: persistentConnection ?? this.persistentConnection,
        reasonPhrase: reasonPhrase ?? this.reasonPhrase,
      );
}
