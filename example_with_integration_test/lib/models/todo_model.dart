import 'package:example_with_integration_test/models/todo_status_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class Todo {
  late String id;
  late DateTime created;
  late DateTime updated;
  late String action;
  late TodoStatus status;

  Todo();

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
