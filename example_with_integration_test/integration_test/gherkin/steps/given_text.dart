import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

final givenTheText = given1<String, FlutterWidgetTesterWorld>(
  'the text {String}',
  (text, world) async {
    print(text);
  },
);
