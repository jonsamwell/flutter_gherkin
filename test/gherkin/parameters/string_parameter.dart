import 'package:flutter_gherkin/src/gherkin/parameters/string_parameter.dart';
import 'package:test/test.dart';

void main() {
  group("StringParameter", () {
    test("{string} parsed correctly", () {
      final parameter = StringParameterLower();
      expect(parameter.transformer("Jon Samwell"), equals("Jon Samwell"));
    });

    test("{String} parsed correctly", () {
      final parameter = StringParameterCamel();
      expect(parameter.transformer("Jon Samwell"), equals("Jon Samwell"));
    });
  });
}
