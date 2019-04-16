import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_run_result.dart';

import 'json_row.dart';

class JsonStep {
  String keyword;
  String name;
  int line;
  String file;
  String status;
  String error;
  int duration;
  List<JsonRow> rows = [];

  static JsonStep from(StepStartedMessage message) {
    final step = JsonStep();

    final index = message.name.indexOf(" ");
    final keyword = message.name.substring(0, index + 1);
    final name = message.name.substring(index + 1, message.name.length);

    step.keyword = keyword;
    step.name = name;
    step.line = message.context.lineNumber;
    step.file = message.context.filePath;

    if ((message.table?.rows?.length ?? 0) > 0) {
      step.rows = message.table.rows.map((r) => JsonRow(r.columns.toList())).toList();
      step.rows.insert(0, JsonRow(message.table.header.columns.toList()));
    }

    return step;
  }

  void onFinish(StepFinishedMessage message) {
    duration = message.result.elapsedMilliseconds * 1000000; // nano seconds.

    switch (message.result.result) {
      case StepExecutionResult.pass:
        status = "passed";
        break;
      case StepExecutionResult.skipped:
        status = "skipped";
        break;
      default:
        status = "failed";
    }

    _trackError(message.result.resultReason);
  }

  void onException(Exception exception, StackTrace stackTrace) {
    _trackError(exception.toString());
  }

  void _trackError(String error) {
    if (this.error == null && (error?.length ?? 0) > 0) {
      this.error = "$file:$line\n$keyword$name\n\n$error";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {
      "keyword": keyword,
      "name": name,
      "line": line,
      "result": {
        "status": status,
        "duration": duration,
      },
    };

    if (rows.isNotEmpty) {
      result["rows"] = rows.map((row) => row.toJson()).toList();
    }

    if (error != null) {
      result["result"]["error_message"] = error;
    }

    return result;
  }
}