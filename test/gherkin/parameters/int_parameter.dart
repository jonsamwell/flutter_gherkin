import 'package:flutter_gherkin/src/gherkin/parameters/int_parameter.dart';
import 'package:test/test.dart';

void main() {
  group("IntParameter", () {
    test("{int} parsed correctly", () {
      final parameter = IntParameterLower();
      expect(parameter.transformer("12"), equals(12));
    });

    test("{Int} parsed correctly", () {
      final parameter = IntParameterCamel();
      expect(parameter.transformer("12"), equals(12));
    });
  });
}
