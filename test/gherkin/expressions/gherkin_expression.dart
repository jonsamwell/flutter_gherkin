import 'package:flutter_gherkin/src/gherkin/expressions/gherkin_expression.dart';
import 'package:flutter_gherkin/src/gherkin/parameters/int_parameter.dart';
import 'package:flutter_gherkin/src/gherkin/parameters/string_parameter.dart';
import 'package:flutter_gherkin/src/gherkin/parameters/word_parameter.dart';
import 'package:flutter_gherkin/src/gherkin/parameters/float_parameter.dart';
import 'package:flutter_gherkin/src/gherkin/parameters/plural_parameter.dart';
import 'package:test/test.dart';

void main() {
  group("GherkinExpression", () {
    test('parse simple regex expression correctly', () async {
      final parser = new GherkinExpression(RegExp('I (open|close) the drawer'),
          [WordParameterLower(), WordParameterCamel()]);

      expect(parser.isMatch("I open the drawer"), equals(true));
      expect(parser.isMatch("I close the drawer"), equals(true));
      expect(parser.isMatch("I sausage the drawer"), equals(false));
      expect(parser.getParameters("I close the drawer"), equals(["close"]));
    });

    test('parse complex regex with custom parameters expression correctly',
        () async {
      final parser = new GherkinExpression(
          RegExp(
              'I (open|close) the drawer {int} time(s) and find {word} which is (good|bad)'),
          [WordParameterLower(), IntParameterLower(), PluralParameter()]);

      expect(
          parser.isMatch(
              "I open the drawer 2 times and find 'socks' which is good"),
          equals(true));
      expect(
          parser.isMatch(
              "I close the drawer 1 time and find 'pants' which is good"),
          equals(true));
      expect(
          parser.isMatch(
              "I sausage the drawer 919293 times and find 'parsley' which is good"),
          equals(false));
      expect(
          parser.getParameters(
              "I open the drawer 6 times and find 'socks' which is bad"),
          equals(["open", 6, "socks", "bad"]));
    });

    test('parse simple {word} expression correctly', () async {
      final parser = new GherkinExpression(RegExp('I am {word} as {Word}'),
          [WordParameterLower(), WordParameterCamel()]);

      expect(parser.isMatch("I am 'happy'"), equals(false));
      expect(parser.isMatch("I am 'happy' as 'Larry'"), equals(true));
      expect(parser.getParameters("I am 'happy' as 'Larry'"),
          equals(["happy", "Larry"]));
    });

    test('parse simple {string} expression correctly', () async {
      final parser = new GherkinExpression(
          RegExp('I am {string}'), [StringParameterLower()]);

      expect(parser.isMatch("I am 'happy as Larry'"), equals(true));
      expect(parser.getParameters("I am 'happy as Larry'"),
          equals(["happy as Larry"]));
    });

    test('parse simple {int} expression correctly', () async {
      final parser = new GherkinExpression(
          RegExp('I am {int} years and {Int} days old'),
          [IntParameterLower(), IntParameterCamel()]);

      expect(parser.isMatch("I am 150 years and 19 days old"), equals(true));
      expect(parser.getParameters("I am 150 years and 19 days old"),
          equals([150, 19]));
    });

    test('parse simple {float} expression correctly', () async {
      final parser = new GherkinExpression(
          RegExp('I am {float} years and {Float} days old'),
          [FloatParameterLower(), FloatParameterCamel()]);

      expect(
          parser.isMatch("I am 150.232 years and 19.4 days old"), equals(true));
      expect(parser.getParameters("I am 150.53 years and 19.00942 days old"),
          equals([150.53, 19.00942]));
    });

    test('parse simple plural (s) expression correctly', () async {
      final parser = new GherkinExpression(
          RegExp('I have {int} cucumber(s) in my belly'),
          [IntParameterLower(), PluralParameter()]);

      expect(parser.isMatch("I have 1 cucumber in my belly"), equals(true));
      expect(parser.isMatch("I have 42 cucumbers in my belly"), equals(true));
      expect(
          parser.getParameters("I have 1 cucumber in my belly"), equals([1]));
      expect(parser.getParameters("I have 42 cucumbers in my belly"),
          equals([42]));
    });

    test('parse complex expression correctly', () async {
      final parser = new GherkinExpression(
          RegExp(
              '{word} {int} {string} {int} (jon|laurie) {float} {word} {float} cucumber(s)'),
          [
            WordParameterLower(),
            StringParameterLower(),
            IntParameterLower(),
            FloatParameterLower(),
            PluralParameter()
          ]);

      expect(
          parser.isMatch(
              "'word' 22 'a string' 09 jon 3.14 'hello' 3.333 cucumber"),
          equals(true));
      expect(
          parser.isMatch(
              "'word' 22 'a string' 09 laurie 3.14 'hello' 3.333 cucumbers"),
          equals(true));
      expect(
          parser.getParameters(
              "'word' 22 'a string' 09 laurie 3.14 'hello' 3.333 cucumbers"),
          equals(["word", 22, "a string", 9, "laurie", 3.14, "hello", 3.333]));
    });
  });
}
