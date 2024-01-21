// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:new_gardenifi_app/src/common_widgets/alert_dialogs.dart';
import 'package:new_gardenifi_app/src/constants/mqtt_constants.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/program_controller.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class AddRemoveValveWidget extends ConsumerWidget {
  const AddRemoveValveWidget(this.port, {super.key});

  final String port;

  // Method to sort by number the list of valves
  List<String> sortList(List<String> list) {
    var intList = list.map(int.parse).toList();
    intList.sort();
    var sortedList = intList.map((e) => e.toString()).toList();
    return sortedList;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = ref.read(appLocalizationsProvider);
    var enabledValves = ref.watch(valvesTopicProvider);

    return FloatingActionButton(
      backgroundColor:
          enabledValves.contains(port) ? Colors.grey : Colors.green.withOpacity(0.5),
      onPressed: () async {
        // if the port is not registered, add it and send message to broker with new list to [valves] topic
        if (!enabledValves.contains(port)) {
          enabledValves.add(port);
          ref.read(mqttControllerProvider.notifier).sendMessage(valvesTopic,
              MqttQos.atLeastOnce, jsonEncode(sortList(enabledValves)), true);
        }
        // if the port is already registered prompt user and then remove it and send message to broker with new list to [valves] topic.
        else if (enabledValves.contains(port)) {
          if (ref.read(statusTopicProvider)['out$port'] == 1) {
            await showAlertDialog(
                defaultActionText: loc.okLabel,
                context: context,
                title: loc.valveIsOnDialogTitle,
                content: loc.valveIsOnDialogContent);
            Navigator.pop(context);
          } else {
            var res = await showAlertDialog(
                context: context,
                title: loc.valveDeletionDialogTitle,
                defaultActionText: loc.yesLabel,
                content: loc.valveDeletionDialogContent,
                cancelActionText: loc.cancelLabel);
            if (res == true) {
              enabledValves.remove(port);
              ref.read(programProvider).deleteProgram(int.parse(port));
              ref.read(mqttControllerProvider.notifier).sendMessage(valvesTopic,
                  MqttQos.atLeastOnce, jsonEncode(sortList(enabledValves)), true);
            } else {}
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            port.toString(),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            !enabledValves.contains(port) ? loc.addValveLabel : loc.removeValveLabel,
            style: const TextStyle(color: Colors.black45, fontSize: 12),
          )
        ],
      ),
    );
  }
}
