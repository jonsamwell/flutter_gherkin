import 'package:gherkin/gherkin.dart';
import 'colour_parameter.dart';

class GivenIPickAColour extends Given1<Colour> {
  @override
  Future<void> executeStep(Colour input1) async {
    print("The picked colour was: '$input1'");
  }

  @override
  RegExp get pattern => RegExp(r'I pick the colour {colour}');
}
