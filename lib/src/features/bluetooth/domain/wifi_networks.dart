import 'dart:convert';

import 'package:new_gardenifi_app/src/features/bluetooth/domain/wifi_network.dart';
import 'package:new_gardenifi_app/src/features/mqtt/domain/mqtt_broker.dart';

class WifiNetworks {
  final int page;
  final int pages;
  final List<WifiNetwork> nets;
  final String hwId;
  final MqttBroker mqttBroker;

  WifiNetworks(this.page, this.pages, this.nets, this.hwId, this.mqttBroker);

  factory WifiNetworks.fromJson(dynamic json) {
    
    String result = json.replaceAll("'", "\"");
    dynamic jsonObject = jsonDecode(result);
    var page = jsonObject['page'];
    var pages = jsonObject['pages'];
    var hwId = jsonObject['hw_id'];
    MqttBroker mqttBroker = MqttBroker.fromJson(jsonObject['mqtt_broker']);
    List<WifiNetwork> nets = List<WifiNetwork>.from(
        jsonObject['nets'].map((network) => WifiNetwork.fromJson(network)));
    return WifiNetworks(page as int, pages as int, nets, hwId, mqttBroker);
  }

  Map<String, dynamic> toJson() => {
        'page': page,
        'pages': pages,
        'nets': nets,
      };

  @override
  String toString() {
    return '{$page, $pages, $nets, $hwId, $mqttBroker ';
  }
}
