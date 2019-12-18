# Running the example

To run this example:

1. Ensure dart is accessible in the command line (on your path variable)
2. Ensure an emulator or device is connected
3. In a command prompt (from the root of this library):
    ```bash
    cd example/test_driver

    dart app_test.dart
    ```
This will run the features files found in the folder `test_driver/features` against this example app.

## Debugging the example

To debug this example and step through the library code.

1. Set a break point in `test_driver/app_test.dart`
2. Set `exitAfterTestRun` on the configuration to false to ensure exiting cleanly as the IDE will handle exiting
3. If you are in VsCode you will simply be able to select `Debug example` from the dropdown in the `debugging tab` as the `launch.json` has been configured.
    - otherwise you will need to run a debugging session against `test_driver/app_test.dart`.
