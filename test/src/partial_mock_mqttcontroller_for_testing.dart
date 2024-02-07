import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';

class PartialMockMqttControllerForTesting extends MqttController {
  PartialMockMqttControllerForTesting(super.ref);

  @override
  void subscribeToTopics() {}
}

final partialMqttControllerProvider = Provider<PartialMockMqttControllerForTesting>(
    (ref) => PartialMockMqttControllerForTesting(ref));
