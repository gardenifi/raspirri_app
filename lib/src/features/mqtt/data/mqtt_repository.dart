import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';
import 'package:typed_data/typed_buffers.dart';
import 'package:typed_data/typed_data.dart';

enum MqttCurrentConnectionState {
  idle,
  connecting,
  connected,
  disconnected,
  errorWhenConnecting,
}

enum MqttSubscriptionState {
  idle,
  subscribed,
}

class MqttRepository {
  MqttRepository(this.ref);
  final Ref ref;
  late MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.idle;
  late MqttServerClient client;

  MqttServerClient initializeMqttClient(String host, int port, String identifier) {
    final MqttConnectMessage connectMessage =
        MqttConnectMessage().withClientIdentifier(identifier);

    client = MqttServerClient.withPort(host, identifier, port);
    client.logging(on: true);
    client.keepAlivePeriod = 5;
    client.secure = true;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.connectionMessage = connectMessage;
    client.autoReconnect = false;
    client.onBadCertificate = (dynamic certificateData) => true;
    return client;
  }

  Future<void> connectClient(
      MqttServerClient client, String username, String password) async {
    try {
      await client.connect(username, password);
    } on NoConnectionException catch (_) {
      // Raised by the client when connection fails - Rethrow to Controller
      rethrow;
    } on SocketException catch (_) {
      // Raised by the socket layer - Rethrow to Controller
      rethrow;
    }
  }

  void disconnect(MqttServerClient client) {
    client.disconnect();
  }

  void subscribeToTopic(MqttClient client, String topicName) {
    client.subscribe(topicName, MqttQos.atLeastOnce);
  }

  void publishMessage(String topic, MqttQos qos, String message, bool retain) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    if (message.isNotEmpty) {
      var buf = Uint8Buffer();

      buf.addAll(utf8.encode(message));
      builder.addBuffer(buf);

      final payload = builder.payload;
      client.publishMessage(topic, qos, payload!, retain: retain);
    }
  }

  void onConnected() {
    connectionState = MqttCurrentConnectionState.connected;
    ref.read(disconnectedProvider.notifier).state = false;
    ref.read(connectedProvider.notifier).state = true;
  }

  void onDisconnected() {
    connectionState = MqttCurrentConnectionState.disconnected;
    ref.read(disconnectedProvider.notifier).state = true;
    ref.read(connectedProvider.notifier).state = false;
  }
}

// ----------- PROVIDERS ------------------

final repositoryProvider = Provider<MqttRepository>((ref) {
  return MqttRepository(ref);
});
