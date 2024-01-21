import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/common_widgets/screen_upper_portrait.dart';
import 'package:new_gardenifi_app/src/common_widgets/bottom_screen_widget.dart';
import 'package:new_gardenifi_app/src/common_widgets/button_placeholder.dart';
import 'package:new_gardenifi_app/src/common_widgets/error_message_widget.dart';
import 'package:new_gardenifi_app/src/common_widgets/no_bluetooth_widget.dart';
import 'package:new_gardenifi_app/src/common_widgets/progress_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/data/bluetooth_repository.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_connection/widgets/could_not_connect_bluetooth_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_connection/widgets/device_not_found_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_connection/widgets/pairing_success_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_controller.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/wifi_connection/screens/wifi_setup_screen.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class BluetoothConnectionScreen extends ConsumerStatefulWidget {
  const BluetoothConnectionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BluetoothConnectinScreenState();
}

class _BluetoothConnectinScreenState extends ConsumerState<BluetoothConnectionScreen> {
  bool deviceConnected = false;
  late BluetoothDevice raspiDevice;

  @override
  void initState() {
    // Start scan for devices and listening the stream
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bluetoothControllerProvider.notifier).startScanStream();
      ref.read(bluetoothControllerProvider.notifier).startScan();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loc = ref.read(appLocalizationsProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final radius = screenHeight / 4;

    // Variable that watch the state of the bluetooth adapter
    final bluetoothAdapterProvider = ref.watch(bluetoothAdapterStateStreamProvider);

    final bool isBluetoothOn =
        bluetoothAdapterProvider.value == BluetoothAdapterState.on ? true : false;

    // Variable that watch if device found
    AsyncValue<BluetoothDevice?> scanResultState = ref.watch(bluetoothControllerProvider);

    return WillPopScope(
      // If user press the back button during scanning stop scan and unsubscribe from stream
      onWillPop: () async {
        ref.read(bluetoothControllerProvider.notifier).stopScan();
        return true;
      }, //stopStreamAndScan,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(229, 255, 255, 255),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  ScreenUpperPortrait(
                    radius: radius,
                    showMenuButton: false,
                    showLogo: true,
                  ),
                  !isBluetoothOn
                      ? Expanded(child: NoBluetoothWidget(ref: ref))
                      : Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: buildFindingDeviceWidget(scanResultState),
                              ),
                              if (!deviceConnected)
                                // A placeholder instead of button while device is not connected
                                const ButtonPlaceholder(),
                              if (deviceConnected)
                                // When device connect show the button
                                BottomWidget(
                                  context: context,
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                  isBluetoothOn: isBluetoothOn,
                                  text: loc.goToWifiSetupScreenText,
                                  buttonText: loc.continueButtonLabel,
                                  ref: ref,
                                  callback: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WiFiSetupScreen(raspiDevice)));
                                  },
                                )
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFindingDeviceWidget(AsyncValue<BluetoothDevice?> scanResultState) {
    final loc = ref.read(appLocalizationsProvider);
    return scanResultState.when(
        data: (device) {
          if (device != null) {
            setState(() {
              raspiDevice = device;
            });
            return buildConnectionWidget(raspiDevice);
          } else {
            return DeviceNotFoundWidget(ref: ref);
          }
        },
        error: (error, stackTrace) => ErrorMessageWidget(error.toString()),
        loading: () => ProgressWidget(
              title: loc.searchingDeviceTitle,
              subtitle: loc.searchingDeviceSubtitle,
            ));
  }

  Widget buildConnectionWidget(BluetoothDevice device) {
    final loc = ref.read(appLocalizationsProvider);
    // Variable that watch the connection with device
    final connectionState = ref.watch(connectionProvider);

    return connectionState.when(
      data: (state) {
        if (state == BluetoothConnectionState.connected) {
          setState(() {
            deviceConnected = true;
          });
          return const PairingSuccessWidget();
        } else {
          setState(() {
            deviceConnected = false;
          });
          return CouldNotConnectBluetoothWidget(ref: ref, device: device);
        }
      },
      error: (error, stackTrace) => ErrorMessageWidget(error.toString()),
      loading: () => ProgressWidget(
        title: loc.connectingDeviceTitle,
        subtitle: loc.connectingDeviceSubtitle,
      ),
    );
  }
}
