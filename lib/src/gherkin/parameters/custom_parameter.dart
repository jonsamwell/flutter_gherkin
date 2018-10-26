typedef TValue Transformer<TValue>(String value);

/// A class used to define and parse custom parameters in step definitions
/// see https://docs.cucumber.io/cucumber/cucumber-expressions/#custom-parameter-types
abstract class CustomParameter<T> {
  /// the name in the step definition to search for.  This is combined with the identifier prefix / suffix to create a replacable token
  /// that signals this parameter for example "My name is {string}" so the name would be "string".
  final String name;

  /// the regex pattern that can parse the step string
  /// For example:
  ///   Template: "My name is {string}"
  ///   Step:     "My name is 'Jon'"
  ///   Regex:    "['|\"](.*)['|\"]"
  /// The above regex would pull out the work "Jon from the step"
  final RegExp pattern;

  /// A transformer function that takes a string and return the correct type of this parameter
  final Transformer<T> transformer;

  /// The prefix used for the name token to identify this parameter.  Defaults to "{".
  final String identifierPrefix;

  /// The suffix used for the name token to identify this parameter.  Defaults to "}".
  final String identifierSuffix;

  /// If this parameter should be included in the list of step arguments.  Defaults to true.
  final bool includeInParameterList;

  String get identifier => "$identifierPrefix$name$identifierSuffix";

  CustomParameter(this.name, this.pattern, this.transformer,
      {this.identifierPrefix = "{",
      this.identifierSuffix = "}",
      this.includeInParameterList = true});
}
