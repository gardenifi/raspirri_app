import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/common_widgets/screen_upper_landscape.dart';
import 'package:new_gardenifi_app/src/common_widgets/screen_upper_portrait.dart';
import 'package:new_gardenifi_app/src/common_widgets/snackbar.dart';
import 'package:new_gardenifi_app/src/constants/colors.dart';
import 'package:new_gardenifi_app/src/constants/gaps.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/widgets/can_not_connect_to_broker_widget.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/widgets/device_disconnected.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/widgets/disconnected_from_broker_widget.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/no_valves_widget.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/valves_widget.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';
import 'package:new_gardenifi_app/utils.dart';

class ProgramsScreen extends ConsumerStatefulWidget {
  const ProgramsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends ConsumerState<ProgramsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Setup a client and connect it to broker
    ref.read(mqttControllerProvider.notifier).setupAndConnectClient();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh screen when app resumes from background
    if (state == AppLifecycleState.resumed) {
      refreshMainScreen(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = ref.read(appLocalizationsProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final radius = screenHeight / 4;

    final mqttControllerValue = ref.watch(mqttControllerProvider);
    final listOfValves = ref.watch(valvesTopicProvider);
    final statusTopicMessage = ref.watch(statusTopicProvider);

    final bool cantConnectToBroker = ref.watch(cantConnectProvider);
    final bool disconnectedFromBroker = ref.watch(disconnectedProvider);
    final bool hasConnectionError = (statusTopicMessage.containsKey('err') &&
        statusTopicMessage['err'] == 'LOST_CONNECTION');
    final bool canShowAllMenuOptions = (!hasConnectionError && !cantConnectToBroker);


    // When connection to broker is successful show snackbar
    ref.listen(connectedProvider, (previous, next) {
      if (next) {
        showSnackbar(context, loc.connectedToBrokerSnackbarText,
            icon: Icons.done, color: Colors.greenAccent);
      }
    });

    return Scaffold(
        backgroundColor: screenBackgroundColor,
        body: OrientationBuilder(builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? Column(
                  children: [
                    ScreenUpperPortrait(
                        radius: radius,
                        showMenuButton: true,
                        showAddRemoveMenu: canShowAllMenuOptions,
                        showInitializeMenu: true,
                        showRebootMenu: canShowAllMenuOptions,
                        showUpdateMenu: canShowAllMenuOptions,
                        showLogo: true),
                    mqttControllerValue.when(
                      data: (data) {
                        return cantConnectToBroker
                            ? const CanNotConnectToBrokerWidget()
                            : hasConnectionError
                                ? const DeviceDisconnectedWidget()
                                : (listOfValves.isEmpty)
                                    ? const NoValvesWidget()
                                    : (disconnectedFromBroker)
                                        ? const DisconnectedFromBrokerWidget()
                                        : ValvesWidget(listOfValves: listOfValves);
                      },
                      error: (error, stackTrace) => Center(child: Text(error.toString())),
                      loading: () => const Expanded(
                          child: Center(child: CircularProgressIndicator())),
                    ),
                  ],
                )
              : SafeArea(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScreenUpperLandscape(
                          radius: screenHeight / 3,
                          showMenuButton: true,
                        showAddRemoveMenu: canShowAllMenuOptions,
                        showInitializeMenu: canShowAllMenuOptions,
                        showRebootMenu: canShowAllMenuOptions,
                        showUpdateMenu: canShowAllMenuOptions,
                        showLogo: true),
                      gapW20,
                      Expanded(
                        child: Column(
                          children: [
                            mqttControllerValue.when(
                              data: (data) {
                                return cantConnectToBroker
                                    ? const CanNotConnectToBrokerWidget()
                                    : (statusTopicMessage.containsKey('err') &&
                                            statusTopicMessage['err'] ==
                                                'LOST_CONNECTION')
                                        ? const DeviceDisconnectedWidget()
                                        : (listOfValves.isEmpty)
                                            ? const NoValvesWidget()
                                            : (disconnectedFromBroker)
                                                ? const DisconnectedFromBrokerWidget()
                                                : ValvesWidget(
                                                    listOfValves: listOfValves);
                              },
                              error: (error, stackTrace) =>
                                  Center(child: Text(error.toString())),
                              loading: () => const Expanded(
                                  child: Center(child: CircularProgressIndicator())),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
        }));
  }
}
