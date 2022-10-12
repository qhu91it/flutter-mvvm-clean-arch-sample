import '../models.dart';

class ApiBaseResponse<T> {
  ApiErrorResponse? error;
  T? data;
  ApiBaseResponse({this.error, this.data});
}
