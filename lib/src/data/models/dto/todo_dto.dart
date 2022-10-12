import 'package:objectbox/objectbox.dart';

@Entity()
class TodoDto {
  int id;
  final String description;
  final bool completed;

  TodoDto({
    this.id = 0,
    required this.description,
    this.completed = false,
  });

  factory TodoDto.create({
    int id = 0,
    required String description,
  }) {
    return TodoDto(
      id: id,
      description: description,
    );
  }

  factory TodoDto.update(TodoDto old, String description) {
    return TodoDto(
      id: old.id,
      description: description,
      completed: old.completed,
    );
  }

  factory TodoDto.toggle(TodoDto old, bool completed) {
    return TodoDto(
      id: old.id,
      description: old.description,
      completed: completed,
    );
  }
}
