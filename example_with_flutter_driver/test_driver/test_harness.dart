import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin_with_driver.dart';
import 'package:gherkin/gherkin.dart';

Future<void> main(List<String> arguments) {
  final config = FlutterDriverTestConfiguration.standard(
    []
  );

  return GherkinRunner().execute(config);
}