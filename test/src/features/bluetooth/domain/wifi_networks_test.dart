import 'package:flutter_test/flutter_test.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/domain/wifi_network.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/domain/wifi_networks.dart';
import 'package:new_gardenifi_app/src/features/mqtt/domain/mqtt_broker.dart';

import '../../../commons.dart';

void main() {
  group('WifiNetworks', () {
    test('WifiNetworks.fromJson should create a WifiNetworks instance from a json', () {
      const String json =
          "{'hw_id': '100000005fd258b6', 'mqtt_broker': {'host': 'c12571319ea54c799a95ff68a20755c9.s1.eu.hivemq.cloud', 'port': 8883, 'user': 'raspirriv1', 'pass': 'R@sp1r1v119785923'}, 'page': 2, 'nets': [{'id': 8, 'ssid': 'DIRECT-9A-HP DeskJet 4530 series'}], 'pages': 2}";
      // run
      final wifiNetworks = WifiNetworks.fromJson(json);
      // verify
      expect(wifiNetworks.page, 2);
      expect(wifiNetworks.pages, 2);
      expect(
          wifiNetworks.nets,
          equals([
            WifiNetwork.fromJson({'id': 8, 'ssid': 'DIRECT-9A-HP DeskJet 4530 series'})
          ]));
      expect(wifiNetworks.hwId, '100000005fd258b6');
      expect(
          wifiNetworks.mqttBroker,
          equals(MqttBroker.fromJson({
            'host': 'c12571319ea54c799a95ff68a20755c9.s1.eu.hivemq.cloud',
            'port': 8883,
            'user': 'raspirriv1',
            'pass': 'R@sp1r1v119785923'
          })));
    });

    test(
        'toString method should return a formatted string representation of WifiNetworks',
        () {
      // setup
      final wifiNetworks = fakeWifiNetworks;
      // run
      const String expected =
          "{2, 2, [{8, DIRECT-9A-HP DeskJet 4530 series, }], 100000005fd258b6, {c12571319ea54c799a95ff68a20755c9.s1.eu.hivemq.cloud, 8883, raspirriv1, R@sp1r1v119785923} ";
      expect(wifiNetworks.toString(), expected);
    });
  });
}
