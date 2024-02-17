import 'package:flutter/material.dart' hide Listener;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_gardenifi_app/src/common_widgets/error_message_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/data/bluetooth_repository.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_controller.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/wifi_connection/screens/wifi_connection_screen.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/wifi_connection/screens/wifi_setup_screen.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/wifi_connection/widgets/connection_wifi_success_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/wifi_connection/widgets/could_not_connect_to_internet_widget.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';

import '../../commons.dart';
import '../../mocks.dart';

class WifiRobot {
  WifiRobot(this.tester);
  WidgetTester tester;
  final mockObserver = MockNavigatorObserver();

  // final mockObserver = MockNavigatorObserver();

  Future<void> pumpWifiSetupScreen({
    required BluetoothDevice device,
    required bool bluetoothIsOn,
    required BluetoothConnectionState? deviceConnectionState,
    bool pumpAndSettle = true,
    bool hasObserver = false,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
          overrides: [
            connectionProvider
                .overrideWith((ref) => Stream.value(deviceConnectionState!)),
            wifiNetworksFutureProvider
                .overrideWith((ref) => [fakeWifiNetwork1, fakeWifiNetwork2]),
            bluetoothIsOn
                ? bluetoothAdapterStateStreamProvider
                    .overrideWith((ref) => Stream.value(BluetoothAdapterState.on))
                : bluetoothAdapterStateStreamProvider
                    .overrideWith((ref) => Stream.value(BluetoothAdapterState.off)),
          ],
          child: MaterialApp(
            navigatorObservers: hasObserver ? [mockObserver] : [],
            home: WiFiSetupScreen(device),
          )),
    );
    if (pumpAndSettle) {
      await tester.pumpAndSettle();
    }
  }

  ProviderContainer getProviderContainer() {
    final context = tester.element(find.byType(WiFiSetupScreen));
    final container = ProviderScope.containerOf(context);
    return container;
  }

  void expectFindDropdownButton(Finder dropdownFinder) {
    expect(dropdownFinder, findsOneWidget);
  }

  void expectFindPasswordTextField(Finder textFieldFinder) {
    expect(textFieldFinder, findsOneWidget);
  }

  void expectDropdownButtonHasNoValue() {
    expect(find.text('MyNetwork1'), findsNothing);
  }

  void expectProvidersHaveInitialValue(ProviderContainer container) {
    expect(container.read(ssidProvider), '');
    expect(container.read(passwordProvider), '');
  }

  Future<void> tapDropdownButton(Finder dropdownFinder) async {
    // After fetching networks, DropdownButton has no value selected
    final offset = tester.getCenter(dropdownFinder);
    await tester.tapAt(offset);
    await tester.pumpAndSettle();
  }

  void expectDropdownButtonHasValue() {
    final valueFinder = find.text('MyNetwork1');
    expect(valueFinder, findsOneWidget);
  }

  void expectPasswordTextFieldIsDisabled(Finder textFieldFinder) {
    final textFieldWidgetBefore = tester.widget<TextField>(textFieldFinder);
    expect(textFieldWidgetBefore.enabled, false);
  }

  void expectPasswordTextFieldIsEnabled(Finder textFieldFinder) {
    final textFieldWidgetBefore = tester.widget<TextField>(textFieldFinder);
    expect(textFieldWidgetBefore.enabled, true);
  }

  void expectConnectButtonIsNotEnabled() {
    final connectButtonFinder = find.widgetWithText(ElevatedButton, 'Continue');
    expect(connectButtonFinder, findsNothing);
  }

  Future<void> tapAndSelectNetwork(Finder dropdownFinder) async {
    expectFindDropdownButton(dropdownFinder);
    await tapDropdownButton(dropdownFinder);
    await tester.tap(find.text('MyNetwork1'));
    await tester.pumpAndSettle();
  }

  Future<void> enterPassowrdToTextField(String password) async {
    final textFieldfFinder = find.byType(TextField);
    expect(textFieldfFinder, findsOneWidget);
    await tester.enterText(textFieldfFinder, password);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
  }

  void expectProvidersUpdatedTheirState(ProviderContainer container) {
    expect(container.read(ssidProvider), 'MyNetwork1');
    expect(container.read(passwordProvider), '1234');
  }

  Future<void> tapRefreshListButton() async {
    expect(find.text('Refresh list'), findsOneWidget);
    // During test taping on RefreshList button returns error due to its offset. So i am getting the center of the button and then tap on it.
    final offset = tester.getCenter(find.text('Refresh list'));
    await tester.tapAt(offset);
    await tester.pumpAndSettle();
  }

  void expectConnectButtonIsEnabled() {
    final connectButtonFinder = find.widgetWithText(ElevatedButton, 'Connect');
    final connectButtonWidget = tester.widget<ElevatedButton>(connectButtonFinder);
    expect(connectButtonFinder, findsOneWidget);
    expect(connectButtonWidget.enabled, true);
    expect(connectButtonWidget.onPressed, isNotNull);
  }

  Future<void> tapContinueButton() async {
    final finder = find.widgetWithText(ElevatedButton, 'Connect');
    expect(finder, findsOneWidget);
    final offset = tester.getCenter(finder);
    await tester.tapAt(offset);
    await tester.pumpAndSettle();
  }

  void expectNavigatorPushedNewScreen() {
    verify(() => mockObserver.didPush(any(), any())).called(greaterThan(0));
  }

  Future<void> pumpWifiConnectionScreenWithSuccess(String value) async {
    registerFallbackValue(FakeRoute());
    final mockMqttController = MockMqttController(const AsyncData(null));

    when(() => mockMqttController.setupAndConnectClient())
        .thenAnswer((_) => Future.value());

    await tester.pumpWidget(ProviderScope(
        overrides: [
          wifiConnectionStatusProvider.overrideWith((ref) => value),
          mqttControllerProvider.overrideWith((ref) => mockMqttController),
          valvesTopicProvider.overrideWith((ref) => ['1', '2']),
          statusTopicProvider.overrideWith((ref) => {}),
          cantConnectProvider.overrideWith((ref) => true),
          disconnectedProvider.overrideWith((ref) => false),
          connectedProvider.overrideWith((ref) => false)
        ],
        child: MaterialApp(
          navigatorObservers: [mockObserver],
          home: const WifiConnectionScreen(),
        )));

    await tester.pumpAndSettle();
  }

  Future<void> pumpWifiConnectionScreenWithError() async {
    await tester.pumpWidget(ProviderScope(
        overrides: [
          wifiConnectionStatusProvider.overrideWith((_) => Future.error('error')),
        ],
        child: const MaterialApp(
          home: WifiConnectionScreen(),
        )));

    await tester.pumpAndSettle();
  }

  void expectConnectionWifiSuccessWidget() {
    final finder = find.byType(ConnectionWifiSuccessWidget);
    expect(finder, findsOneWidget);
  }

  void expectCouldNotConnectToInternetWidget() {
    final finder = find.byType(CouldNotConnectToInternetWidget);
    expect(finder, findsOneWidget);
  }

  void expectErrorMessageWidget() {
    final finder = find.byType(ErrorMessageWidget);
    expect(finder, findsOneWidget);
  }

  void expectFindContinueButton() {
    final finder = find.widgetWithText(ElevatedButton, 'Continue');
    final button = tester.widget<ElevatedButton>(finder);
    expect(finder, findsOneWidget);
    expect(button.onPressed, isNotNull);
  }

  Future<void> tapContinueToMainScreenButton() async {
    final finder = find.widgetWithText(ElevatedButton, 'Continue');
    final button = tester.widget<ElevatedButton>(finder);
    final offset = tester.getCenter(finder);

    expect(finder, findsOneWidget);
    expect(button.onPressed, isNotNull);
    await tester.tapAt(offset);
    await tester.pumpAndSettle();
  }

  void expectNavigateToProgramScreen() {
    verify(() => mockObserver.didReplace(
          newRoute: any(named: 'newRoute'),
          oldRoute: any(named: 'oldRoute'),
        )).called(1);
  }

}
