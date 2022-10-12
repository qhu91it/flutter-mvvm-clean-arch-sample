// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'src/data/models/dto/todo_dto.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(2, 8689488324942816644),
      name: 'TodoDto',
      lastPropertyId: const IdUid(3, 5516187230501677900),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8036067328816162546),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 1734272648821767271),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 5516187230501677900),
            name: 'completed',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(2, 8689488324942816644),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [2644972917318538580],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        3374531818322462764,
        6644601102632524227,
        7929326240730046873
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    TodoDto: EntityDefinition<TodoDto>(
        model: _entities[0],
        toOneRelations: (TodoDto object) => [],
        toManyRelations: (TodoDto object) => {},
        getId: (TodoDto object) => object.id,
        setId: (TodoDto object, int id) {
          object.id = id;
        },
        objectToFB: (TodoDto object, fb.Builder fbb) {
          final descriptionOffset = fbb.writeString(object.description);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, descriptionOffset);
          fbb.addBool(2, object.completed);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = TodoDto(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              description: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              completed: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 8, false));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [TodoDto] entity fields to define ObjectBox queries.
class TodoDto_ {
  /// see [TodoDto.id]
  static final id = QueryIntegerProperty<TodoDto>(_entities[0].properties[0]);

  /// see [TodoDto.description]
  static final description =
      QueryStringProperty<TodoDto>(_entities[0].properties[1]);

  /// see [TodoDto.completed]
  static final completed =
      QueryBooleanProperty<TodoDto>(_entities[0].properties[2]);
}
