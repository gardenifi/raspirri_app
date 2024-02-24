import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/data/bluetooth_repository.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_controller.dart';
import 'package:new_gardenifi_app/src/features/mqtt/data/mqtt_repository.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/program_controller.dart';

class MockMqttRepository extends Mock implements MqttRepository {}

class MockMqttServerClient extends Mock implements MqttServerClient {}

class MockMqttClient extends Mock implements MqttClient {
  MockMqttClient.withPort(String server, String identifier, int port);
}

class MockBluetoothRepository extends Mock implements BluetoothRepository {}

class MockScanResult extends Mock implements ScanResult {}

class MockBluetoothController extends StateNotifier<AsyncValue<BluetoothDevice?>>
    with Mock
    implements BluetoothController {
  MockBluetoothController(AsyncValue<BluetoothDevice?> initialValue)
      : super(initialValue);
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route {}

class MockProgramController extends Mock implements ProgramController {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

class MockMqttController extends StateNotifier<AsyncValue<void>>
    with Mock
    implements MqttController {
  
  MockMqttController(AsyncValue<void> initialValue) : super(initialValue);
}

