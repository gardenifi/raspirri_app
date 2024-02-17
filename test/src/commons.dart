import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/domain/wifi_network.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/domain/wifi_networks.dart';
import 'package:new_gardenifi_app/src/features/mqtt/domain/mqtt_broker.dart';

final fakeWifiNetwork1 = WifiNetwork(1, 'MyNetwork1', 'password1');
final fakeWifiNetwork2 = WifiNetwork(2, 'MyNetwork2', 'password2');

final fakeWifiNetworks = WifiNetworks(
    2,
    2,
    [WifiNetwork(8, 'DIRECT-9A-HP DeskJet 4530 series', '')],
    '100000005fd258b6',
    MqttBroker.fromJson({
      'host': 'c12571319ea54c799a95ff68a20755c9.s1.eu.hivemq.cloud',
      'port': 8883,
      'user': 'raspirriv1',
      'pass': 'R@sp1r1v119785923'
    }));

final Map<String, dynamic> fakeWifiNetworkJson = {
  'id': 1,
  'ssid': 'MyNetwork1',
  'password': 'password1',
};

final fakeBluetoothDevice = BluetoothDevice(
  remoteId: const DeviceIdentifier('raspirriv1'),
);

final fakeBluetoothCharacteristic = BluetoothCharacteristic(
    remoteId: const DeviceIdentifier('raspirriv1'),
    serviceUuid: Guid('1a2b3c4d'),
    characteristicUuid: Guid('1a2b3c4d'));
