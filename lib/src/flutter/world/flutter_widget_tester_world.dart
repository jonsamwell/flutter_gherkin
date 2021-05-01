import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';

/// The world object that can be used to store state during a single test.
/// It also allows interaction with the app under test through the `appDriver`
/// which exposes an instance of `AppDriverAdapter` and an
/// instance of `WidgetTester` via the property `rawAppDriver`
class FlutterWidgetTesterWorld
    extends FlutterTypedAdapterWorld<WidgetTester, Finder, Widget> {}
