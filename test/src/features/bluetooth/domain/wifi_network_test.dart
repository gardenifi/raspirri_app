import 'package:flutter_test/flutter_test.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/domain/wifi_network.dart';

void main() {
  group(
    'WifiNetwork',
    () {
      test('WifiNetwork.fromJson should create a WifiNetwork instance from json', () {
        // setup
        final Map<String, dynamic> json = {
          'id': 1,
          'ssid': 'MyNetwork',
          'password': 'password',
        };
        // run
        final wifiNetwork = WifiNetwork.fromJson(json);
        // verify
        expect(wifiNetwork.id, equals(1));
        expect(wifiNetwork.ssid, equals('MyNetwork'));
        expect(wifiNetwork.password, equals('password'));
      });

      test('toJson should convert WifiNetwork to json', () {
        // setup
        final wifiNetwork = WifiNetwork(1, 'MyNetwork', 'password');

        // run
        final json = wifiNetwork.toJson();

        // verify
        final Map<String, dynamic> expected = {
          'id': 1,
          'ssid': 'MyNetwork',
          'password': 'password',
        };
        expect(json, expected);
      });

      test(
          'toString method should return a formatted string representation of WifiNetwork',
          () {
        // setup
        final wifiNetwork = WifiNetwork(1, 'MyNetwork', 'password');
        // run
        const String expected = '{1, MyNetwork, password}';
        expect(wifiNetwork.toString(), expected);
      });
    },
  );
}
