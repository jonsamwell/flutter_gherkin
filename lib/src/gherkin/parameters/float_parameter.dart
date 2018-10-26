import 'package:flutter_gherkin/src/gherkin/parameters/custom_parameter.dart';

class FloatParameterBase extends CustomParameter<num> {
  FloatParameterBase(String name)
      : super(name, RegExp("([0-9]+.[0-9]+)"), (String input) {
          final n = num.parse(input);
          return n;
        });
}

class FloatParameterLower extends FloatParameterBase {
  FloatParameterLower() : super("float");
}

class FloatParameterCamel extends FloatParameterBase {
  FloatParameterCamel() : super("Float");
}

class NumParameterLower extends FloatParameterBase {
  NumParameterLower() : super("num");
}

class NumParameterCamel extends FloatParameterBase {
  NumParameterCamel() : super("Num");
}
