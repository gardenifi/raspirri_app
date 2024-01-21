import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/common_widgets/screen_upper_portrait.dart';
import 'package:new_gardenifi_app/src/common_widgets/bottom_screen_widget.dart';
import 'package:new_gardenifi_app/src/common_widgets/button_placeholder.dart';
import 'package:new_gardenifi_app/src/common_widgets/no_bluetooth_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/data/bluetooth_repository.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_controller.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_connection/widgets/connection_lost_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/wifi_connection/widgets/error_fetching_networks_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/wifi_connection/widgets/refresh_networks_button.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/wifi_connection/widgets/wait_while_fetching_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/wifi_connection/screens/wifi_connection_screen.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class WiFiSetupScreen extends ConsumerStatefulWidget {
  const WiFiSetupScreen(this.device, {super.key});

  final BluetoothDevice device;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WiFiSetupScreenState();
}

class _WiFiSetupScreenState extends ConsumerState<WiFiSetupScreen> {
  String ssid = '';

  bool passwordSelected = false;

  bool networkSelected = false;

  bool passwordVisibility = false;

  String password = '';

  TextEditingController controller = TextEditingController();

  late final focusNode = FocusNode();

  /// Rebuild the screen with [setState]
  void dropdownCallback(String? selectedValue) {
    setState(() {
      ssid = selectedValue!;
      networkSelected = true;
      ref.read(ssidProvider.notifier).state = ssid;
    });
  }

  /// Destroy the current provider state and refresh it
  void rebuildWidget() {
    ref.invalidate(wifiNetworksFutureProvider);
    setState(() {
      ssid = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = ref.read(appLocalizationsProvider);
    // Variable to watch the state of the bluetooth adapter
    final bluetoothAdapterProvider = ref.watch(bluetoothAdapterStateStreamProvider);
    // Variable to watch the state of the bluetooth connection
    final connectionState = ref.watch(connectionProvider);

    final bool isBluetoothOn =
        bluetoothAdapterProvider.value == BluetoothAdapterState.on ? true : false;

    final bool isConnected =
        connectionState.value == BluetoothConnectionState.connected ? true : false;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final radius = screenHeight / 4;

    final nets = ref.watch(wifiNetworksFutureProvider);

    controller.text = password;

    return Scaffold(
      backgroundColor: const Color.fromARGB(229, 255, 255, 255),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                ScreenUpperPortrait(
                    radius: radius, showMenuButton: false, showLogo: true),
                !isBluetoothOn
                    ? Expanded(child: NoBluetoothWidget(ref: ref))
                    : !isConnected
                        ? ConnectionLostWidget(widget.device)
                        : nets.when(
                            data: (data) {
                              // Since Riverpod 2.0 after a provider has emmited an [AsyncValue.data] or [AsyncValue.error], tha provider will no longer emit an [AsyncValue.loading]. Instead it will re-emit the latest value, but with the property [AsyncValue.isLoading] to true.
                              // So to account with this when we refresh the widget we just check if [isLoading] value is true and if it is then show a progress indicator.
                              return nets.isLoading
                                  ? const WaitWhileFetchingWidget()
                                  : Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(12.0),
                                                  child: Text(
                                                      loc.selectNetworkLabel),
                                                ),
                                                SizedBox(
                                                  width: 300,
                                                  height: 60,
                                                  child: InputDecorator(
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            loc.selectNetworkHintText,
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(15),
                                                            gapPadding: 1)),
                                                    isEmpty: ssid == '',
                                                    child: DropdownButtonHideUnderline(
                                                        child: DropdownButton<String>(
                                                      menuMaxHeight: 400,
                                                      value: ssid == '' ? null : ssid,
                                                      onChanged: dropdownCallback,
                                                      isExpanded: true,
                                                      items: data
                                                          .map((e) => DropdownMenuItem(
                                                              value: e.ssid,
                                                              child: Text(e.ssid)))
                                                          .toList(),
                                                    )),
                                                  ),
                                                ),
                                                RefreshNetworksButton(
                                                    callback: rebuildWidget),
                                                const SizedBox(height: 50),
                                                SizedBox(
                                                  width: 300,
                                                  height: 60,
                                                  child: TextField(
                                                    keyboardType:
                                                        TextInputType.visiblePassword,
                                                    enabled:
                                                        networkSelected ? true : false,
                                                    controller: controller,
                                                    obscureText:
                                                        passwordVisibility ? false : true,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(15)),
                                                      labelText:
                                                          loc.enterPasswordLabel,
                                                      suffixIcon: InkWell(
                                                        onTap: () => setState(() {
                                                          passwordVisibility =
                                                              !passwordVisibility;
                                                          password = controller.text;
                                                          controller.selection =
                                                              TextSelection.fromPosition(
                                                                  TextPosition(
                                                                      offset: password
                                                                          .length));
                                                        }),
                                                        child: passwordVisibility
                                                            ? const Icon(
                                                                Icons.visibility_off)
                                                            : const Icon(
                                                                Icons.visibility),
                                                      ),
                                                    ),
                                                    onSubmitted: (givenText) {
                                                      setState(() {
                                                        password = givenText;
                                                        ref
                                                            .read(
                                                                passwordProvider.notifier)
                                                            .state = password;
                                                        passwordSelected = true;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          passwordSelected
                                              ? BottomWidget(
                                                  context: context,
                                                  screenWidth: screenWidth,
                                                  screenHeight: screenHeight,
                                                  isBluetoothOn: isBluetoothOn,
                                                  text:
                                                      loc.connectToNetworkText,
                                                  buttonText: loc.connectToNetworkButtonLabel,
                                                  ref: ref,
                                                  callback: () async {
                                                    ref.invalidate(
                                                        wifiConnectionStatusProvider);
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          const WifiConnectionScreen(),
                                                    ));
                                                  })
                                              : const ButtonPlaceholder(),
                                        ],
                                      ),
                                    );
                            },
                            error: (error, stackTrace) {
                              return nets.isLoading
                                  ? const WaitWhileFetchingWidget()
                                  : ErrorFetchingNetworksWidget(callback: rebuildWidget);
                            },
                            loading: () => const WaitWhileFetchingWidget(),
                          ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
