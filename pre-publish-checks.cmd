CALL "C:\Google\flutter\bin\cache\dart-sdk\bin\dartanalyzer" --options analysis_options.yaml .
CALL "C:\Google\flutter\bin\cache\dart-sdk\bin\dartfmt" . -w
CALL flutter packages upgrade
CALL flutter test