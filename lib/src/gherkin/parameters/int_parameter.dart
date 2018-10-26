import 'package:flutter_gherkin/src/gherkin/parameters/custom_parameter.dart';

class IntParameterBase extends CustomParameter<int> {
  IntParameterBase(String name)
      : super(name, RegExp("([0-9]+)"), (String input) {
          final n = int.parse(input, radix: 10);
          return n;
        });
}

class IntParameterLower extends IntParameterBase {
  IntParameterLower() : super("int");
}

class IntParameterCamel extends IntParameterBase {
  IntParameterCamel() : super("Int");
}
