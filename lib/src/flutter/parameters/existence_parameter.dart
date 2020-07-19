import 'package:gherkin/gherkin.dart';

enum Existence {
  present,
  absent,
}

class ExistenceParameter extends CustomParameter<Existence> {
  ExistenceParameter()
      : super(
          'existence',
          RegExp(r'(present|absent)', caseSensitive: true),
          (c) {
            switch (c) {
              case 'present':
                return Existence.present;
              case 'absent':
                return Existence.absent;
              default:
                throw ArgumentError(
                    'Value `$c` must be defined for this Existence parameter');
            }
          },
        );
}
