import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/program.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_gardenifi_app/src/constants/mqtt_constants.dart';
import 'package:new_gardenifi_app/src/features/mqtt/data/mqtt_repository.dart';

class MqttController extends StateNotifier<AsyncValue<void>> {
  MqttController(this.ref) : super(const AsyncLoading());

  MqttServerClient? client;
  final Ref ref;
  late String hwId;

  Future<void> setupAndConnectClient() async {
    final mqttRepository = ref.read(repositoryProvider);
    final prefs = await SharedPreferences.getInstance();
    final String user = prefs.getString('mqtt_user') ?? '';
    final String password = prefs.getString('mqtt_pass') ?? '';
    final String host = prefs.getString('mqtt_host') ?? '';
    final int port = prefs.getInt('mqtt_port') ?? 0;

    client = mqttRepository.initializeMqttClient(host, port, indentifier);

    try {
      await mqttRepository.connectClient(client!, user, password);
    } on NoConnectionException catch (_) {
      // Raised by the client when connection fails.
      ref.read(cantConnectProvider.notifier).state = true;
      // Stop loading
      state = const AsyncData(null);
      // disconnectFromBroker();
    } on SocketException catch (_) {
      // Raised by the socket layer
      ref.read(cantConnectProvider.notifier).state = true;
      // Stop loading
      state = const AsyncData(null);
    }

    subscribeToTopics();
  }

  Future<void> loadHardwareId() async {
    final prefs = await SharedPreferences.getInstance();
    hwId = prefs.getString('hwId') ?? '';
  }

  String createTopicName(topic) {
    return '$baseTopic/$hwId/$topic';
  }

  void subscribeToTopics() async {
    final mqttRepository = ref.read(repositoryProvider);
    await loadHardwareId();
    final status = createTopicName(statusTopic);
    final config = createTopicName(configTopic);
    final metadata = createTopicName(metadatTopic);
    final valves = createTopicName(valvesTopic);

    mqttRepository.subscribeToTopic(client!, valves);
    mqttRepository.subscribeToTopic(client!, status);
    mqttRepository.subscribeToTopic(client!, config);
    mqttRepository.subscribeToTopic(client!, metadata);

    client!.updates!.listen((event) {
      // Stop loading state
      state = const AsyncData(null);
      // Get the message from the broker (from any topic)
      final MqttPublishMessage receivedMessage = event[0].payload as MqttPublishMessage;
      final topic = event[0].topic;

      final String tempMessage =
          MqttPublishPayload.bytesToStringAsString(receivedMessage.payload.message);

      final message = const Utf8Decoder().convert(tempMessage.codeUnits);

      if (topic == valves) {
        final correctedMessage = message.replaceAll("'", "\"");

        List<String> listOfValvesFromBroker =
            (jsonDecode(correctedMessage) as List<dynamic>).cast<String>();
        ref.read(valvesTopicProvider.notifier).state = listOfValvesFromBroker;
      }

      if (topic == status) {
        final String replacedString = message.replaceAll('\'', '"');

        final Map<String, dynamic> mes = jsonDecode(replacedString);
        ref.read(statusTopicProvider.notifier).state = mes;
      }

      if (topic == metadata) {
        final String replacedString = message.replaceAll('\'', '"');

        final Map<String, dynamic> mes = jsonDecode(replacedString);
        ref.read(metadataTopicProvider.notifier).state = mes;
      }

      if (topic == config) {
        // Convert received message to List<Program>
        List<Program> scheduleUtcFromBroker = (json.decode(message) as List).map((e) {
          Program program = Program.fromJson(e);
          return program;
        }).toList();
        // update the provider who holds the programs
        ref.read(configTopicProvider.notifier).state = scheduleUtcFromBroker;
      }
    });
  }

  void sendMessage(String topic, MqttQos qos, String message, bool retain) {
    final mqttRepository = ref.read(repositoryProvider);
    final topicToSend = createTopicName(topic);
    mqttRepository.publishMessage(topicToSend, qos, message, retain);
  }

  void disconnectFromBroker() {
    final mqttRepository = ref.read(repositoryProvider);
    mqttRepository.disconnect(client!);
  }

  void rebootDevice() {
    ref
        .read(mqttControllerProvider.notifier)
        .sendMessage(commandTopic, MqttQos.atLeastOnce, jsonEncode(rebootCmd), false);
  }

  void updateSever() {
    ref
        .read(mqttControllerProvider.notifier)
        .sendMessage(commandTopic, MqttQos.atLeastOnce, jsonEncode(updateCmd), false);
  }
}

// ------------> Providers <--------------

final mqttControllerProvider =
    StateNotifierProvider<MqttController, AsyncValue>((ref) => MqttController(ref));

final valvesTopicProvider = StateProvider<List<String>>((ref) => []);

final statusTopicProvider = StateProvider<Map<String, dynamic>>((ref) => {});

final metadataTopicProvider = StateProvider<Map<String, dynamic>>((ref) => {});

final configTopicProvider = StateProvider<List<Program>>((ref) => []);

final disconnectedProvider = StateProvider<bool>((ref) => false);

final cantConnectProvider = StateProvider<bool>((ref) => false);

final connectedProvider = StateProvider<bool>(((ref) => false));
