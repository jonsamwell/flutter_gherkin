import 'package:gherkin/gherkin.dart';

enum SwipeDirection { down, left, right, up }

class SwipeDirectionParameter extends CustomParameter<SwipeDirection> {
  SwipeDirectionParameter()
      : super(
          'swipe_direction',
          RegExp(r'(down|left|right|up)', caseSensitive: true),
          (c) {
            switch (c) {
              case 'down':
                return SwipeDirection.down;
              case 'left':
                return SwipeDirection.left;
              case 'right':
                return SwipeDirection.right;
              case 'up':
                return SwipeDirection.up;
              default:
                throw ArgumentError(
                    '"down", "left", "right", or "up" must be defined for this parameter');
            }
          },
        );
}
