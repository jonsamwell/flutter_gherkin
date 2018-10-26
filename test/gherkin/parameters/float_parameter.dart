import 'package:flutter_gherkin/src/gherkin/parameters/float_parameter.dart';
import 'package:test/test.dart';

void main() {
  group("FloatParameter", () {
    test("{float} parsed correctly", () {
      final parameter = FloatParameterLower();
      expect(parameter.transformer("12.243"), equals(12.243));
    });

    test("{Float} parsed correctly", () {
      final parameter = FloatParameterCamel();
      expect(parameter.transformer("12.243"), equals(12.243));
    });

    test("{num} parsed correctly", () {
      final parameter = NumParameterLower();
      expect(parameter.transformer("12.243"), equals(12.243));
    });

    test("{Num} parsed correctly", () {
      final parameter = NumParameterCamel();
      expect(parameter.transformer("12.243"), equals(12.243));
    });
  });
}
