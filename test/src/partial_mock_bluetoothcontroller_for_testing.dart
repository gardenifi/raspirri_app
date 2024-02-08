import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_controller.dart';

import 'mocks.dart';

class PartialMockBluetoothControllerForTesting extends BluetoothController {
  final MockBluetoothRepository mockRepository;
  PartialMockBluetoothControllerForTesting(this.mockRepository, ref)
      : super(mockRepository, ref);

  @override
  Future<void> writeToDevice(String data) {
    return Future.value();
  }

  @override
  Future<List<int>> readFromDevice(BluetoothCharacteristic char) async {
   String jsonString = "{'hw_id': '1234', 'mqtt_broker': {'host': '1234', 'port': 8883, 'user': 'raspirriv1', 'pass': '1234'}, 'page': 1, 'nets': [{'id': 1, 'ssid': 'myNetwork'}], 'pages': 2}";

  List<int> charCodes = jsonString.codeUnits;
    return charCodes;
  }
}
