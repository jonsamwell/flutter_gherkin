import 'package:flutter_gherkin/src/gherkin/parameters/custom_parameter.dart';

class StringParameterBase extends CustomParameter<String> {
  StringParameterBase(String name)
      : super(name, RegExp("['|\"](.*)['|\"]"), (String input) => input);
}

class StringParameterLower extends StringParameterBase {
  StringParameterLower() : super("string");
}

class StringParameterCamel extends StringParameterBase {
  StringParameterCamel() : super("String");
}
