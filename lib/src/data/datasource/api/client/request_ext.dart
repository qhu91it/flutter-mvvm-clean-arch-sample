import 'package:http/http.dart';

/// Extends [BaseRequest] to provide copied instances.
extension BaseRequestCopyWith on BaseRequest {
  BaseRequest copyWith() {
    if (this is Request) {
      return RequestCopyWith(this as Request).copyWith();
    } else if (this is StreamedRequest) {
      return StreamedRequestCopyWith(this as StreamedRequest).copyWith();
    } else if (this is MultipartRequest) {
      return MultipartRequestCopyWith(this as MultipartRequest).copyWith();
    }

    throw UnsupportedError(
        'Cannot copy unsupported type of request $runtimeType');
  }
}

/// Extends [Request] to provide copied instances.
extension RequestCopyWith on Request {
  Request copyWith() {
    final copied = Request(
      method,
      url,
    )..body = body;

    copied.body = body;

    copied.bodyBytes = bodyBytes;

    return copied
      ..headers.addAll(headers)
      ..encoding = encoding
      ..followRedirects = followRedirects
      ..maxRedirects = maxRedirects
      ..persistentConnection = persistentConnection;
  }
}

/// Extends [StreamedRequest] to provide copied instances.
extension StreamedRequestCopyWith on StreamedRequest {
  StreamedRequest copyWith() {
    final req = StreamedRequest(
      method,
      url,
    )
      ..headers.addAll(headers)
      ..followRedirects = followRedirects
      ..maxRedirects = maxRedirects
      ..persistentConnection = persistentConnection;

    return req;
  }
}

/// Extends [MultipartRequest] to provide copied instances.
extension MultipartRequestCopyWith on MultipartRequest {
  MultipartRequest copyWith() => MultipartRequest(
        method,
        url,
      )
        ..headers.addAll(headers)
        ..fields.addAll(fields)
        ..files.addAll(files)
        ..followRedirects = followRedirects
        ..maxRedirects = maxRedirects
        ..persistentConnection = persistentConnection;
}
