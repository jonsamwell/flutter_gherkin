library flutter_gherkin.builder;

import 'package:build/build.dart';
import 'package:flutter_gherkin/src/flutter/code_generation/generators/gherkin_suite_test_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder gherkinTestSuiteBuilder(BuilderOptions options) =>
    SharedPartBuilder([GherkinSuiteTestGenerator()], 'gherkin_tests');
