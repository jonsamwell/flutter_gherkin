import 'package:gherkin/gherkin.dart';

class MockParameter extends CustomParameter<String> {
  MockParameter()
      : super(
          'MockStringParam',
          RegExp('a'),
          (a) => 'a',
        );
}
