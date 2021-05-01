CALL flutter analyze
CALL "C:\Google\flutter\bin\cache\dart-sdk\bin\dartfmt" . -w
CALL flutter packages upgrade
CALL flutter test --no-sound-null-safety