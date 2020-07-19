import 'package:gherkin/gherkin.dart';
import 'colour_parameter.dart';

StepDefinitionGeneric GivenIPickAColour() {
  return given1(
    'I pick the colour {colour}',
    (Colour colour, _) async {
      print("The picked colour was: '$colour'");
    },
  );
}
