import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

final thenIExpectFailure = then<FlutterWorld>(
  'I expect a failure',
  (context) async {
    expect([1, 2, 3], equals([1, 2]));
  },
);
