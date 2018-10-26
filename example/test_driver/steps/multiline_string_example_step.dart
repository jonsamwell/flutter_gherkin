import 'package:flutter_gherkin/flutter_gherkin.dart';

/// This step expects a multiline string proceeding it
/// 
/// For example: 
/// 
/// `Given I provide the following "review" comment`
///  """ 
///  Some comment
///  """
class GivenIProvideAComment extends Given2<String, String> {
  @override
  Future<void> executeStep(String commentType, String comment) async {
    // TODO: implement executeStep
  }

  @override
  RegExp get pattern => RegExp(r"I provide the following {string} comment");
}
