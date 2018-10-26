import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';

class GivenIPickAColour extends Given1<Color> {
  @override
  Future<void> executeStep(Color input1) async {
    // TODO: implement executeStep
  }

  @override
  RegExp get pattern => RegExp(r"I pick a {colour}");
}
