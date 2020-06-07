import 'dart:async';
import 'dart:io';

import 'package:gherkin/gherkin.dart';
import 'package:meta/meta.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Upload messages and logs as the delivery layer for the [SlackReporter].
class SlackMessenger {
  /// After [creating a Slack Bot](https://api.slack.com/apps) with
  /// the proper scopes (chat.write, files:write), an Oauth token will be
  /// generated after installing for your Slack team (https://api.slack.com/apps/xxx/install-on-team)
  ///
  /// If the images aren't uploading, test your token on Slack: https://api.slack.com/methods/files.upload/test
  /// Often, the solution is to invite the bot to the proper Slack channel.
  final String slackOauthToken;

  /// Easiest way to find this: right click the channel name in Slack>"Open Link" .
  /// Use the alphanumeric ending of the URL.
  final String slackChannelId;

  /// The message to reply to. This will nest the test run, reducing channel noise.
  String threadTs;

  SlackMessenger({
    @required this.slackOauthToken,
    @required this.slackChannelId,
  });

  /// Format a Slack text Block
  Map<String, dynamic> buildTextSection(String txt) => {
        'type': 'section',
        'text': {'type': 'mrkdwn', 'text': txt}
      };

  /// Slack Block divider
  Map<String, dynamic> get divider => {'type': 'divider'};

  Future<void> message(msg, level) async {
    if (level == MessageLevel.error) await sendText(msg);
  }

  Future<http.Response> notifySlack(List<Map<String, dynamic>> payload) => http
      .post(
        'https://slack.com/api/chat.postMessage',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $slackOauthToken',
        },
        body: jsonEncode({
          'channel': slackChannelId,
          'blocks': payload,
          if (threadTs != null) 'thread_ts': threadTs,
        }),
      )
      .catchError(print);

  /// Send normal text. Slack-supported Markdown is available.
  Future<http.Response> sendText(String msg) {
    final payload = [buildTextSection(msg)];
    return notifySlack(payload);
  }

  /// Initial message will set [threadTs] so that subsequent messages reply under one thread.
  Future<http.Response> start(String startMessage) async {
    threadTs = null;
    final resp = await sendText(startMessage);
    threadTs = jsonDecode(resp.body)['ts'];
    return resp;
  }

  Future<void> uploadScreenshot(String path, String title) async {
    try {
      if (slackOauthToken != null) {
        // pulled from https://api.slack.com/methods/files.upload/test
        final endpoint = _slackEndpoint('files.upload', {
          'channels': slackChannelId,
          if (threadTs != null) 'thread_ts': threadTs,
          'title': title,
        });
        final request = http.MultipartRequest('POST', Uri.parse(endpoint));
        final file = await http.MultipartFile.fromPath('file', path);
        request.files.add(file);
        return request.send();
      }
    } catch (e, st) {
      print('Failed to take screenshot\n$e\n$st');
    }
  }

  String _slackEndpoint(String method, Map<String, String> queryParameters) {
    final baseUrl = 'https://slack.com/api/$method?token=$slackOauthToken';
    return queryParameters.entries.fold(baseUrl, (acc, entry) {
      final encoded = Uri.encodeComponent(entry.value);
      return '$acc&${entry.key}=$encoded';
    });
  }
}

/// Notify a Slack channel for every failed step and every successful feature.
/// This requires a bot installed to your workspace with the files:write scope
/// (to upload screenshots of failed steps) and the chat.write permission
/// (to publish test results).
///
/// Refer to [SlackMessenger] for steps to setup and configure your bot.
class SlackReporter extends Reporter {
  /// The number of scenario failures before the test suite will terminate
  /// and cease reporting to Slack.
  final int maximumToleratedFailures;

  final SlackMessenger slackMessenger;

  /// Reported on the parent thread of the test run.
  final String startLabel;

  final features = <FinishedMessage>[];
  final scenarios = <ScenarioFinishedMessage>[];
  final scenariosInActiveFeature = <ScenarioFinishedMessage>[];
  StepFinishedMessage firstFailedStepInActiveScenario;

  SlackReporter(this.slackMessenger,
      {this.startLabel, this.maximumToleratedFailures = 15});

  @override
  Future<void> onException(exception, stackTrace) {
    final payload = [
      slackMessenger.divider,
      slackMessenger.buildTextSection(':bangbang: Exception :bangbang:'),
      slackMessenger.buildTextSection(exception.toString()),
      slackMessenger.buildTextSection('```$stackTrace```'),
      slackMessenger.divider,
    ];

    return slackMessenger.notifySlack(payload);
  }

  @override
  Future<void> message(msg, level) async {
    if (level == MessageLevel.error) await slackMessenger.sendText(msg);
  }

  @override
  Future<void> onFeatureFinished(feature) async {
    features.add(feature);
    final allScenariosPassed = scenariosInActiveFeature.every((s) => s.passed);

    if (allScenariosPassed) {
      await slackMessenger.sendText(
          ':white_check_mark: ${feature.name} (${scenariosInActiveFeature.length}/${scenariosInActiveFeature.length} passed)');
    } else {
      final passedScenarios = scenariosInActiveFeature.where((s) => s.passed);
      await slackMessenger.sendText(
          ':warning: ${feature.name} (${passedScenarios.length}/${scenariosInActiveFeature.length} passed)');
    }

    scenariosInActiveFeature.clear();
  }

  @override
  Future<void> onScenarioFinished(scenario) async {
    scenarios.add(scenario);
    scenariosInActiveFeature.add(scenario);
    if (!scenario.passed) {
      final payload = [
        slackMessenger.buildTextSection(':x: ${scenario.name}'),
        slackMessenger.buildTextSection(
            'Failed at step: ${firstFailedStepInActiveScenario.name}'),
      ];
      await slackMessenger
          .notifySlack(payload)
          .then((_) => firstFailedStepInActiveScenario = null);
    }

    if (scenarios.where((s) => !s.passed).length > maximumToleratedFailures) {
      await slackMessenger.sendText(
          ':x: :x: :x: :x: Aborting: too many failures :x: :x: :x: :x:');
      exit(1);
    }
  }

  @override
  Future<void> onStepFinished(step) async {
    if (step.result.result != StepExecutionResult.pass &&
        firstFailedStepInActiveScenario == null) {
      firstFailedStepInActiveScenario = step;
    }
  }

  @override
  Future<void> onTestRunStarted() async =>
      slackMessenger.start('Starting tests for $startLabel');

  @override
  Future<void> onTestRunFinished() async {
    final successfulNames =
        scenarios.where((s) => s.passed).map((s) => '* ${s.name}');
    final failedNames =
        scenarios.where((s) => !s.passed).map((s) => '* ${s.name}');

    final payload = [
      slackMessenger.buildTextSection('Testing Complete'),
      slackMessenger.divider,
      slackMessenger.buildTextSection(
          ':white_check_mark: ${successfulNames.length} / ${scenarios.length} Successful Tests:'),
      slackMessenger.buildTextSection(successfulNames.join('\n')),
      slackMessenger.divider,
      slackMessenger.buildTextSection(
          ':x: ${failedNames.length} / ${scenarios.length} Failed Tests:'),
      slackMessenger.buildTextSection(failedNames.join('\n')),
    ];

    return slackMessenger.notifySlack(payload);
  }
}
