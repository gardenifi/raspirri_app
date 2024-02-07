import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:new_gardenifi_app/src/features/mqtt/data/mqtt_repository.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';

import '../../../provider_container.dart';
import '../../../mocks.dart';
import '../../../robot.dart';

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

  setUp(() {
    final container = ProviderContainer();
    mqttRepository = container.read(repositoryProvider);
  });
  test(
    'initialize client return a MqttServerClient with given arguments',
    () {
      // setup
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
    // Create a ProviderContainer for testing
    final container = createContainer();

    // Obtain the initial state of connectedProvider and expect to be false
    final initialState = container.read(connectedProvider.notifier).state;
    expect(initialState, false);

    // Get a ref object for connectedProvider
    final ref = container.readProviderElement(connectedProvider);

    final mqttRepository = MqttRepository(ref);

    // Call onConnected method and expect connectedProvider state to be true
    mqttRepository.onConnected();
    final finalState = container.read(connectedProvider.notifier).state;
    expect(finalState, true);
  });

  test('When disconnecting from broker change the state of disconnectedProvider to true',
      () async {
    // Create a ProviderContainer for testing
    final container = createContainer();

    // Obtain the initial state of connectedProvider and expect to be false
    final initialState = container.read(disconnectedProvider.notifier).state;
    expect(initialState, false);

    // Get a ref object for connectedProvider
    final ref = container.readProviderElement(disconnectedProvider);

    final mqttRepository = MqttRepository(ref);

    // Call onDisconnected method and expect disconnectedProvider state to be true
    mqttRepository.onDisconnected();
    final finalState = container.read(disconnectedProvider.notifier).state;
    expect(finalState, true);
  });
}
