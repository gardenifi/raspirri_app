import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';

// Create this class to override [subscribeToTopics] method during testing when needed
class PartialMockMqttControllerForTesting extends MqttController {
  PartialMockMqttControllerForTesting(super.ref);

  @override
  void subscribeToTopics() {}
}

final partialMqttControllerProvider = Provider<PartialMockMqttControllerForTesting>(
    (ref) => PartialMockMqttControllerForTesting(ref));
