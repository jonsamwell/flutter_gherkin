import 'package:flutter_gherkin/src/gherkin/parameters/custom_parameter.dart';

class WordParameterBase extends CustomParameter<String> {
  WordParameterBase(String name)
      : super(name, RegExp("['|\"](\\w+)['|\"]"), (String input) => input);
}

class WordParameterLower extends WordParameterBase {
  WordParameterLower() : super("word");
}

class WordParameterCamel extends WordParameterBase {
  WordParameterCamel() : super("Word");
}
