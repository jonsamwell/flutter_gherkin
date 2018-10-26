import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';

class ColourParameter extends CustomParameter<Color> {
  ColourParameter()
      : super("colour", RegExp(r"red|green|blue", caseSensitive: true), (c) {
          switch (c.toLowerCase()) {
            case "red":
              return Colors.red;
            case "green":
              return Colors.green;
            case "blue":
              return Colors.blue;
          }
        });
}
