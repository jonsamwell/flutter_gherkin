class RunnableDebugInformation {
  final String filePath;
  final int lineNumber;
  final String lineText;

  RunnableDebugInformation(this.filePath, this.lineNumber, this.lineText);

  RunnableDebugInformation copyWith(int lineNumber, String line) {
    return RunnableDebugInformation(this.filePath, lineNumber, line);
  }
}
