```
# generate the test suite
dart run build_runner build --delete-conflicting-outputs

# re-generate
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs

# run the tests
flutter drive --driver=test_driver/integration_test_driver.dart --target=integration_test/gherkin_suite_test.dart
```
