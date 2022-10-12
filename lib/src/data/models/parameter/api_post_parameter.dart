import 'api_base_parameter.dart';

class ApiAddPostParameter implements ApiBaseParameter {
  final int userId;
  final String title;
  final String body;

  ApiAddPostParameter({
    required this.userId,
    required this.title,
    required this.body,
  });
}
