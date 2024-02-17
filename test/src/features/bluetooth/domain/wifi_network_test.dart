import 'package:flutter_test/flutter_test.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/domain/wifi_network.dart';

import '../../../commons.dart';

void main() {
  group(
    'WifiNetwork',
    () {
      test('WifiNetwork.fromJson should create a WifiNetwork instance from json', () {
        // setup
        final Map<String, dynamic> json = fakeWifiNetworkJson;
        // run
        final wifiNetwork = WifiNetwork.fromJson(json);
        // verify
        expect(wifiNetwork.id, equals(1));
        expect(wifiNetwork.ssid, equals('MyNetwork1'));
        expect(wifiNetwork.password, equals('password1'));
      });

      test('toJson should convert WifiNetwork to json', () {
        // setup
        final wifiNetwork = fakeWifiNetwork1;

        // run
        final json = wifiNetwork.toJson();

        // verify
        final Map<String, dynamic> expected = fakeWifiNetworkJson;
        expect(json, expected);
      });

      test(
          'toString method should return a formatted string representation of WifiNetwork',
          () {
        // setup
        final wifiNetwork = fakeWifiNetwork1;
        // run
        const String expected = '{1, MyNetwork1, password1}';
        expect(wifiNetwork.toString(), expected);
      });
    },
  );
}
