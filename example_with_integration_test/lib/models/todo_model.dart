import 'package:example_with_integration_test/models/todo_status_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class Todo {
  final String id;
  final DateTime created;
  final DateTime updated;
  String? action;
  TodoStatus status;

  Todo({
    required this.id,
    required this.created,
    required this.updated,
    required this.status,
    this.action,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
