import 'package:matcher/matcher.dart';

/// Returns a pretty-printed representation of [value].
///
/// The matcher package doesn't expose its pretty-print function directly, but
/// we can use it through StringDescription.
String prettyPrint(value) =>
    StringDescription().addDescriptionOf(value).toString();

String formatFailure(Matcher expected, actual, String which, {String reason}) {
  final buffer = StringBuffer();
  buffer.writeln(indent(prettyPrint(expected), first: 'Expected: '));
  buffer.writeln(indent(prettyPrint(actual), first: '  Actual: '));
  if (which.isNotEmpty) buffer.writeln(indent(which, first: '   Which: '));
  if (reason != null) buffer.writeln(reason);
  return buffer.toString();
}

/// Indent each line in [string] by [size] spaces.
///
/// If [first] is passed, it's used in place of the first line's indentation and
/// [size] defaults to `first.length`. Otherwise, [size] defaults to 2.
String indent(String string, {int size, String first}) {
  size ??= first == null ? 2 : first.length;
  return prefixLines(string, " " * size, first: first);
}

/// Prepends each line in [text] with [prefix].
///
/// If [first] or [last] is passed, the first and last lines, respectively, are
/// prefixed with those instead. If [single] is passed, it's used if there's
/// only a single line; otherwise, [first], [last], or [prefix] is used, in that
/// order of precedence.
String prefixLines(String text, String prefix,
    {String first, String last, String single}) {
  first ??= prefix;
  last ??= prefix;
  single ??= first ?? last ?? prefix;

  final lines = text.split('\n');
  if (lines.length == 1) return "$single$text";

  final buffer = StringBuffer("$first${lines.first}\n");

  // Write out all but the first and last lines with [prefix].
  for (final line in lines.skip(1).take(lines.length - 2)) {
    buffer.writeln("$prefix$line");
  }
  buffer.write("$last${lines.last}");
  return buffer.toString();
}
