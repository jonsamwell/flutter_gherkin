import 'package:flutter_gherkin/src/gherkin/parameters/custom_parameter.dart';

class PluralParameter extends CustomParameter<String> {
  PluralParameter()
      : super("s", RegExp("(s)?"), (String input) => null,
            identifierPrefix: "(",
            identifierSuffix: ")",
            includeInParameterList: false);
}
