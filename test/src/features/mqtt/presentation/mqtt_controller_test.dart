import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:new_gardenifi_app/src/features/mqtt/data/mqtt_repository.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/cycle.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/program.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../mocks.dart';
import '../../../partial_mock_mqttcontroller_for_testing.dart';
import '../../../provider_container.dart';
import '../../../stream.dart';
import '../data/mqtt_repository_test.dart';

void main() {
  late MockMqttRepository repository;
  late MqttController controller;
  late PartialMockMqttControllerForTesting partialMock;
  late ProviderContainer container;

  setUp(() {
    repository = MockMqttRepository();
    container = createContainer(overrides: [
      repositoryProvider.overrideWithValue(repository),
    ]);

    controller = container.read(mqttControllerProvider.notifier);
    partialMock = container.read(partialMqttControllerProvider);
  });

  test('Initialize Mqtt client with arguments stored by SharedPreferences', () async {
    // setup
    registerFallbackValue(MqttServerClient.withPort('host', 'identifier', 8080));
    SharedPreferences.setMockInitialValues({
      'mqtt_user': 'user',
      'mqtt_pass': '1234',
      'mqtt_host': 'host',
      'mqtt_port': 8080,
    });

    final client = MockMqttServerClient();

    when(() => repository.initializeMqttClient(any(), any(), any())).thenReturn(client);

    when(() => repository.connectClient(any(), any(), any()))
        .thenAnswer((_) => Future.value());

    // run
    await partialMock.setupAndConnectClient();

    // verify
    verify(() => repository.initializeMqttClient('host', 8080, 'gardenifi_app'))
        .called(1);
  });

  test('when connection to broker return SocketException, update state and provider',
      () async {
    // setup
    registerFallbackValue(MqttServerClient.withPort('host', 'identifier', 8080));
    SharedPreferences.setMockInitialValues({
      'mqtt_user': 'user',
      'mqtt_pass': '1234',
      'mqtt_host': 'host',
      'mqtt_port': 8080,
    });
    const exception = SocketException('connection failed');

    final client = MockMqttServerClient();

    when(() => repository.initializeMqttClient(any(), any(), any())).thenReturn(client);

    when(() => repository.connectClient(any(), any(), any())).thenThrow(exception);

    // run
    // Using mockMqttController class to avoid calling [subscribeToTopics] method
    expect(partialMock.state, const AsyncLoading<void>());
    await partialMock.setupAndConnectClient();

    // verify
    expect(container.read(cantConnectProvider.notifier).state, true);
    expect(partialMock.state, const AsyncData<void>(null));
  });

  test('when connection to broker return NoConnectionException, update the provider',
      () async {
    // setup
    registerFallbackValue(MqttServerClient.withPort('host', 'identifier', 8080));
    SharedPreferences.setMockInitialValues({
      'mqtt_user': 'user',
      'mqtt_pass': '1234',
      'mqtt_host': 'host',
      'mqtt_port': 8080,
    });

    final exception = NoConnectionException('connection failed');

    final client = MockMqttServerClient();

    when(() => repository.initializeMqttClient(any(), any(), any())).thenReturn(client);

    when(() => repository.connectClient(any(), any(), any())).thenThrow(exception);

    // run
    // the initial state is AsyncLoading
    expect(partialMock.state, const AsyncLoading<void>());
    await partialMock.setupAndConnectClient();

    // verify
    expect(container.read(cantConnectProvider.notifier).state, true);
    expect(partialMock.state, const AsyncData<void>(null));
  });

  test('loading hwId', () async {
    // setup
    SharedPreferences.setMockInitialValues({'hwId': '1234'});
    // run
    await controller.loadHardwareId();
    // verify
    expect(controller.hwId, '1234');
  });

  test('creating topic name', () {
    // setup
    controller.hwId = '1234';
    // run
    final topicName = controller.createTopicName('myTopic');
    // verify
    expect(topicName, '/raspirri/1234/myTopic');
  });

  test('sending message to topic', () {
    // setup
    registerFallbackValue(MqttQos.atLeastOnce);
    String testTopic = 'topic';
    String expectedTopic = '/raspirri/1324/topic';
    MqttQos testQos = MqttQos.atLeastOnce;
    String testMessage = 'This is a message';
    bool testRetain = true;

    controller.hwId = '1324';

    when(() => repository.publishMessage(any(), any(), any(), any())).thenReturn(null);
    // run
    controller.sendMessage(testTopic, testQos, testMessage, testRetain);
    // verify
    verify(() =>
            repository.publishMessage(expectedTopic, testQos, testMessage, testRetain))
        .called(1);
  });

  test('disconnectFromBroker method calls repository [disconnect]', () {
    // setup
    final client = controller.client = MockServerClient('server', 'clientIdentifier');
    when(() => repository.disconnect(client)).thenReturn(null);
    // run
    controller.disconnectFromBroker();
    // verify
    verify(() => repository.disconnect(client)).called(1);
  });

  test('rebootDevice method sends the appropriate message', () {
    // setup
    registerFallbackValue(MqttQos.atLeastOnce);
    String expectedTopic = '/raspirri/1234/command';
    MqttQos testQos = MqttQos.atLeastOnce;
    String testMessage = '{"cmd":4}';
    bool testRetain = false;

    when(() => repository.publishMessage(any(), any(), any(), any())).thenReturn(null);

    controller.hwId = '1234';
    // run
    controller.rebootDevice();
    // verify
    verify(() =>
            repository.publishMessage(expectedTopic, testQos, testMessage, testRetain))
        .called(1);
  });

  test('updateSever method sends the appropriate message', () {
    // setup
    registerFallbackValue(MqttQos.atLeastOnce);
    String expectedTopic = '/raspirri/1234/command';
    MqttQos testQos = MqttQos.atLeastOnce;
    String testMessage = '{"cmd":6}';
    bool testRetain = false;

    when(() => repository.publishMessage(any(), any(), any(), any())).thenReturn(null);

    controller.hwId = '1234';
    // run
    controller.updateSever();
    // verify
    verify(() =>
            repository.publishMessage(expectedTopic, testQos, testMessage, testRetain))
        .called(1);
  });

  group('Subscribe to topics, listen to the stream and update providers', () {
    test(
      'receive message to topic "valves". Also checking state change from AsyncLoading to AsyncData',
      () async {
        // setup
        registerFallbackValue(MqttClient('server', 'clientIdentifier'));
        SharedPreferences.setMockInitialValues({
          'hwId': '1234',
        });

        final mockServerClient = MockMqttServerClient();

        controller.client = mockServerClient;

        final testStream = createStream(
          topic: '/raspirri/1234/valves',
          text: "['1', '2', '3', '4']",
        );

        when(() => repository.subscribeToTopic(any(), any())).thenReturn(null);

        when(() => mockServerClient.updates).thenAnswer((_) => testStream);

        final subscription = container.listen(valvesTopicProvider, (_, __) {});

        // the initial state must be AsyncLoading
        expect(controller.state, const AsyncLoading<void>());

        // run
        controller.subscribeToTopics();
        await Future.delayed(Duration.zero);

        // verify
        expect(subscription.read(), ['1', '2', '3', '4']);
        // final state must be AsyncData
        expect(controller.state, const AsyncData<void>(null));
      },
    );

    test(
      'receive message to topic "status"',
      () async {
        // setup
        registerFallbackValue(MqttClient('server', 'clientIdentifier'));
        SharedPreferences.setMockInitialValues({
          'hwId': '1234',
        });

        final mockServerClient = MockMqttServerClient();

        controller.client = mockServerClient;

        final testStream = createStream(
          topic: '/raspirri/1234/status',
          text:
              "{'valves': ['1', '2'], 'out1': 0, 'out2': 0, 'out3': 0, 'out4': 0, 'server_time': '2024/02/06 18:42:57', 'tz': 'UTC', 'hw_id': '1234'}",
        );

        when(() => repository.subscribeToTopic(any(), any())).thenReturn(null);

        when(() => mockServerClient.updates).thenAnswer((_) => testStream);

        final subscription = container.listen(statusTopicProvider, (_, __) {});

        // run
        controller.subscribeToTopics();
        await Future.delayed(Duration.zero);
        // verify
        expect(
          subscription.read(),
          {
            'valves': ['1', '2'],
            'out1': 0,
            'out2': 0,
            'out3': 0,
            'out4': 0,
            'server_time': '2024/02/06 18:42:57',
            'tz': 'UTC',
            'hw_id': '1234'
          },
        );
      },
    );

    test(
      'receive message to topic "metadata"',
      () async {
        // setup
        registerFallbackValue(MqttClient('server', 'clientIdentifier'));
        SharedPreferences.setMockInitialValues({
          'hwId': '1234',
        });

        final mockServerClient = MockMqttServerClient();

        controller.client = mockServerClient;

        final testStream = createStream(
          topic: '/raspirri/1234/metadata',
          text:
              "{'ip_address': '192.168.1.171', 'uptime': 'up 2 weeks, 6 days, 1 hour, 36 minutes', 'git_commit': '1234'}",
        );

        when(() => repository.subscribeToTopic(any(), any())).thenReturn(null);

        when(() => mockServerClient.updates).thenAnswer((_) => testStream);

        final subscription = container.listen(metadataTopicProvider, (_, __) {});

        // run
        controller.subscribeToTopics();
        await Future.delayed(Duration.zero);
        // verify
        expect(
          subscription.read(),
          {
            'ip_address': '192.168.1.171',
            'uptime': 'up 2 weeks, 6 days, 1 hour, 36 minutes',
            'git_commit': '1234'
          },
        );
      },
    );

    test(
      'receive message to topic "config"',
      () async {
        // setup
        registerFallbackValue(MqttClient('server', 'clientIdentifier'));
        SharedPreferences.setMockInitialValues({
          'hwId': '1234',
        });

        final mockServerClient = MockMqttServerClient();

        controller.client = mockServerClient;

        final testStream = createStream(
          topic: '/raspirri/1234/config',
          text:
              '[{"out":1,"name":"Garden","days":"mon","cycles":[{"start":"12:07","min":"1"}],"tz_offset":2}]',
        );

        when(() => repository.subscribeToTopic(any(), any())).thenReturn(null);

        when(() => mockServerClient.updates).thenAnswer((_) => testStream);

        final subscription = container.listen(configTopicProvider, (_, __) {});

        // run
        controller.subscribeToTopics();
        await Future.delayed(Duration.zero);
        // verify
        expect(subscription.read(), [
          Program(
              out: 1,
              name: 'Garden',
              days: 'mon',
              cycles: [Cycle(start: '12:07', min: '1')],
              tz_offset: 2)
        ]);
      },
    );
  });
}
