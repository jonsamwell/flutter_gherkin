import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/reporters/aggregated_reporter.dart';
import 'package:test/test.dart';

import '../mocks/reporter_mock.dart';

void main() {
  group("reporters", () {
    test("invokes all child reporters", () async {
      final reporter1 = ReporterMock();
      final reporter2 = ReporterMock();

      final aggregatedReporter = AggregatedReporter();
      aggregatedReporter.addReporter(reporter1);
      aggregatedReporter.addReporter(reporter2);

      await aggregatedReporter.message("", MessageLevel.info);
      expect(reporter1.messageInvocationCount, 1);
      expect(reporter2.messageInvocationCount, 1);

      await aggregatedReporter.onException(null, null);
      expect(reporter1.onExceptionInvocationCount, 1);
      expect(reporter2.onExceptionInvocationCount, 1);

      await aggregatedReporter.onFeatureStarted(null);
      expect(reporter1.onFeatureStartedInvocationCount, 1);
      expect(reporter2.onFeatureStartedInvocationCount, 1);

      await aggregatedReporter.onFeatureFinished(null);
      expect(reporter1.onFeatureFinishedInvocationCount, 1);
      expect(reporter2.onFeatureFinishedInvocationCount, 1);

      await aggregatedReporter.onScenarioFinished(null);
      expect(reporter1.onScenarioFinishedInvocationCount, 1);
      expect(reporter2.onScenarioFinishedInvocationCount, 1);

      await aggregatedReporter.onScenarioStarted(null);
      expect(reporter1.onScenarioStartedInvocationCount, 1);
      expect(reporter2.onScenarioStartedInvocationCount, 1);

      await aggregatedReporter.onStepFinished(null);
      expect(reporter1.onStepFinishedInvocationCount, 1);
      expect(reporter2.onStepFinishedInvocationCount, 1);

      await aggregatedReporter.onStepStarted(null);
      expect(reporter1.onStepStartedInvocationCount, 1);
      expect(reporter2.onStepStartedInvocationCount, 1);

      await aggregatedReporter.onTestRunFinished();
      expect(reporter1.onTestRunfinishedInvocationCount, 1);
      expect(reporter2.onTestRunfinishedInvocationCount, 1);

      await aggregatedReporter.onTestRunStarted();
      await aggregatedReporter.onTestRunStarted();
      expect(reporter1.onTestRunStartedInvocationCount, 2);
      expect(reporter2.onTestRunStartedInvocationCount, 2);

      await aggregatedReporter.dispose();
      expect(reporter1.disposeInvocationCount, 1);
      expect(reporter2.disposeInvocationCount, 1);
    });
  });
}
