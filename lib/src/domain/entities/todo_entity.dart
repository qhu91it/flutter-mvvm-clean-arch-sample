import 'package:equatable/equatable.dart';

import '../../data/models/models.dart';

class TodoEntity implements Equatable {
  final int id;
  final String description;
  final bool completed;

  TodoEntity({
    this.id = 0,
    required this.description,
    this.completed = false,
  });

  factory TodoEntity.fromDto(TodoDto dto) {
    return TodoEntity(
      id: dto.id,
      description: dto.description,
      completed: dto.completed,
    );
  }

  @override
  List<Object?> get props => [id, description, completed];

  @override
  bool? get stringify => true;
}
