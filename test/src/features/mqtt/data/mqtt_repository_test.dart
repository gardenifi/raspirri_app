import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:new_gardenifi_app/src/features/mqtt/data/mqtt_repository.dart';

import '../../../mocks.dart';

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
  test(
    'initialize client return a MqttServerClient with given arguments',
    () {
      // setup
      final client = MqttServerClient.withPort(testHost, testIdentifier, testPort);
      final mockRef = MockRef();
      final mqttRepository = MqttRepository(mockRef);
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
    final mockRef = MockRef();
    final mqttRepository = MqttRepository(mockRef);

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
    final mockRef = MockRef();
    final mqttRepository = MqttRepository(mockRef);
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
    final mockRef = MockRef();
    final mqttRepository = MqttRepository(mockRef);
    status.state = MqttConnectionState.disconnected;

    when(() => mockServerClient.disconnect()).thenReturn(status);
    // run
    mqttRepository.disconnect(mockServerClient);
    expect(status.state, MqttConnectionState.disconnected);
  });

  test('subscribe method is called', () {
    final mockClient = MockClient(testHost, testIdentifier);
    final mockRef = MockRef();
    final mqttRepository = MqttRepository(mockRef);
    final subscription = Subscription();
    when(() => mockClient.subscribe('topic', MqttQos.atLeastOnce))
        .thenReturn(subscription);
    mqttRepository.subscribeToTopic(mockClient, 'topic');
    
    verify(() => mockClient.subscribe('topic', MqttQos.atLeastOnce)).called(1);
  });
}
