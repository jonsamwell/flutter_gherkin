import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'colour_parameter.dart';

class GivenIPickAColour extends Given1<Colour> {
  @override
  Future<void> executeStep(Colour input1) async {
    // TODO: implement executeStep
  }

  @override
  RegExp get pattern => RegExp(r"I pick a {colour}");
}
