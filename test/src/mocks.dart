import 'package:mocktail/mocktail.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:new_gardenifi_app/src/features/mqtt/data/mqtt_repository.dart';

class MockMqttRepository extends Mock implements MqttRepository {}

class MockMqttServerClient extends Mock implements MqttServerClient {}

class MockMqttClient extends Mock implements MqttClient {
  MockMqttClient.withPort(String server, String identifier, int port);
}
