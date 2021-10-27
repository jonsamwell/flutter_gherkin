// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      id: json['id'] as String,
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
      status: $enumDecode(_$TodoStatusEnumMap, json['status']),
      action: json['action'] as String?,
    );

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
      'action': instance.action,
      'status': _$TodoStatusEnumMap[instance.status],
    };

const _$TodoStatusEnumMap = {
  TodoStatus.pending: 'pending',
  TodoStatus.complete: 'complete',
};
