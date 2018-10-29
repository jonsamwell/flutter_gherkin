import 'package:flutter_gherkin/flutter_gherkin.dart';

enum Colour { red, green, blue }

class ColourParameter extends CustomParameter<Colour> {
  ColourParameter()
      : super("colour", RegExp(r"red|green|blue", caseSensitive: true), (c) {
          switch (c.toLowerCase()) {
            case "red":
              return Colour.red;
            case "green":
              return Colour.green;
            case "blue":
              return Colour.blue;
          }
        });
}
