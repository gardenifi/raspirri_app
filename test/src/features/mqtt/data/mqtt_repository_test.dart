import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:new_gardenifi_app/src/features/mqtt/data/mqtt_repository.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';
import 'package:typed_data/typed_data.dart';


class MockServerClient extends Mock implements MqttServerClient {
  MockServerClient(String server, String clientIdentifier);
}

class MockClient extends Mock implements MqttClient {
  MockClient(String server, String clientIdentifier);
}

class MockClientConnectionStatus extends Mock implements MqttClientConnectionStatus {}

void main() {
  const testHost = 'abcd';
  const testPort = 8989;
  const testIdentifier = 'test';
  late MqttRepository mqttRepository;

  setUp(() {});
  test(
    'initialize client return a MqttServerClient with given arguments',
    () {
      // setup
      final container = ProviderContainer();
      mqttRepository = container.read(repositoryProvider);
      final client = MqttServerClient.withPort(testHost, testIdentifier, testPort);
      // run
      final result =
          mqttRepository.initializeMqttClient(testHost, testPort, testIdentifier);
      // verify
      expect(result.server, client.server);
      expect(result.port, client.port);
      expect(result.clientIdentifier, client.clientIdentifier);
    },
  );

  test('connect client succeeds', () async {
    // setup
    final container = ProviderContainer();
    mqttRepository = container.read(repositoryProvider);
    final mockServerClient = MockServerClient(testHost, testIdentifier);
    final status = MqttClientConnectionStatus();
    status.state = MqttConnectionState.connected;

    // stubbing
    when(() => mockServerClient.connect('user', '1234')).thenAnswer((_) {
      return Future.value(status);
    });
    // run
    await mqttRepository.connectClient(mockServerClient, 'user', '1234');
    // verify
    expect(status.state, MqttConnectionState.connected);
    verify(() => mockServerClient.connect('user', '1234')).called(1);
  }, timeout: const Timeout(Duration(seconds: 1)));

  test('connect client fails and return exception', () async {
    // setup
    final container = ProviderContainer();
    mqttRepository = container.read(repositoryProvider);
    final mockServerClient = MockServerClient(testHost, testIdentifier);
    final exception = Exception('connection failed');
    when(() => mockServerClient.connect('user', '1234')).thenThrow(exception);
    // verify
    expect(() async {
      await mqttRepository.connectClient(mockServerClient, 'user', '1234');
    }, throwsException);
    verify(() => mockServerClient.connect('user', '1234')).called(1);
  }, timeout: const Timeout(Duration(seconds: 1)));

  test('client disconnect', () {
    // setup
    final container = ProviderContainer();
    mqttRepository = container.read(repositoryProvider);
    final mockServerClient = MockServerClient(testHost, testIdentifier);
    final status = MqttClientConnectionStatus();
    status.state = MqttConnectionState.disconnected;

    when(() => mockServerClient.disconnect()).thenReturn(status);
    // run
    mqttRepository.disconnect(mockServerClient);
    expect(status.state, MqttConnectionState.disconnected);
  });

  test('subscribe method is called', () {
    // setup
    final container = ProviderContainer();
    mqttRepository = container.read(repositoryProvider);
    final mockClient = MockClient(testHost, testIdentifier);
    final subscription = Subscription();
    when(() => mockClient.subscribe('topic', MqttQos.atLeastOnce))
        .thenReturn(subscription);
    // run
    mqttRepository.subscribeToTopic(mockClient, 'topic');
    // verify
    verify(() => mockClient.subscribe('topic', MqttQos.atLeastOnce)).called(1);
  });

  test('When connecting to broker change the state of connectedProvider to true ',
      () async {
    // setup
    final container = ProviderContainer();
    mqttRepository = container.read(repositoryProvider);

    // Obtain the initial state of connectedProvider and expect to be false
    final initialState = container.read(connectedProvider.notifier).state;
    expect(initialState, false);

    // run
    mqttRepository.onConnected();

    // verify
    final finalState = container.read(connectedProvider.notifier).state;
    expect(finalState, true);
  });

  test('When disconnecting from broker change the state of disconnectedProvider to true',
      () async {
    // setup
    final container = ProviderContainer();
    mqttRepository = container.read(repositoryProvider);

    // Obtain the initial state of connectedProvider and expect to be false
    final initialState = container.read(disconnectedProvider);
    expect(initialState, false);

    // run
    mqttRepository.onDisconnected();

    // verify
    final finalState = container.read(disconnectedProvider);
    expect(finalState, true);
  });

  test('Publish method call [publishMessage] with given arguments', () {
    // setup
    registerFallbackValue(MqttQos.atLeastOnce);
    registerFallbackValue(Uint8Buffer());

    final container = ProviderContainer();
    mqttRepository = container.read(repositoryProvider);

    final mockServerClient = MockServerClient(testHost, testIdentifier);
    mqttRepository.client = mockServerClient;

    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    const String message = 'A message';
    var buf = Uint8Buffer();
    buf.addAll(utf8.encode(message));
    builder.addBuffer(buf);
    final payload = builder.payload;

    when(() => mockServerClient.publishMessage(any(), any(), any(),
        retain: any(named: 'retain'))).thenReturn(1);

    // run
    mqttRepository.publishMessage('topic', MqttQos.atLeastOnce, message, true);
    // verify
    verify(() => mockServerClient.publishMessage('topic', MqttQos.atLeastOnce, payload!,
        retain: true)).called(1);
  });
}
