import 'package:flutter_gherkin/src/gherkin/parameters/string_parameter.dart';
import 'package:test/test.dart';

void main() {
  group("WordParameter", () {
    test("{word} parsed correctly", () {
      final parameter = StringParameterLower();
      expect(parameter.transformer("Jon"), equals("Jon"));
    });

    test("{Word} parsed correctly", () {
      final parameter = StringParameterCamel();
      expect(parameter.transformer("Jon"), equals("Jon"));
    });
  });
}
