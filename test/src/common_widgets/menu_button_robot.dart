import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_gardenifi_app/src/common_widgets/menu_button.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_connection/screens/welcome_screen.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/screens/programs_screen.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/add_remove_valve_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks.dart';

class MenuButtonRobot {
  MenuButtonRobot(this.tester);
  final WidgetTester tester;

  late ProviderContainer container;
  late MockMqttController mockMqttController;

  Future<void> pumpProgramScreen({
    bool doPumpAndSettle = true,
    AsyncValue<void> controllerValue = const AsyncData(null),
    bool cantConnect = false,
    Map<String, dynamic> statusValue = const {},
    List<String> valvesList = const ['1'],
    bool disconnected = false,
  }) async {
    mockMqttController = MockMqttController(controllerValue);

    when(() => mockMqttController.setupAndConnectClient())
        .thenAnswer((_) => Future.value());

    when(() => mockMqttController.rebootDevice()).thenReturn(null);

    await tester.pumpWidget(ProviderScope(
        overrides: [
          mqttControllerProvider.overrideWith((ref) => mockMqttController),
          valvesTopicProvider.overrideWith((ref) => valvesList),
          statusTopicProvider.overrideWith((ref) => statusValue),
          cantConnectProvider.overrideWith((ref) => cantConnect),
          disconnectedProvider.overrideWith((ref) => disconnected),
          connectedProvider.overrideWith((ref) => false)
        ],
        child: MaterialApp(
          routes: {
            'welcomeScreen': (context) => const WelcomeScreen(),
          },
          home: const ProgramsScreen(),
        )));

    if (doPumpAndSettle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
  }

  void expectFindMenuButton() {
    expect(find.byType(MoreMenuButton), findsOneWidget);
  }

  Future<void> tapMenuButton() async {
    await tester.tap(find.byType(MoreMenuButton));
    await tester.pumpAndSettle();
  }

  void expectFindAddRemoveValvesMenuItemButton() {
    expect(find.widgetWithText(MenuItemButton, 'Add/Remove valves'),
        findsOneWidget);
  }

  Future<void> tapAddRemoveValvesButton() async {
    await tester.tap(find.widgetWithText(MenuItemButton, 'Add/Remove valves'));
    await tester.pumpAndSettle();
  }

  void expectFind4AddRemoveValveWidgets() {
    expect(find.byType(AddRemoveValveWidget), findsNWidgets(4));
  }

  Future<void> tapInitializeDeviceButton() async {
    await tester
        .tap(find.widgetWithText(MenuItemButton, 'Initialize IoT device'));
    await tester.pumpAndSettle();
  }

  void expectFindAlertDialog() {
    expect(find.widgetWithText(TextButton, 'Ok'), findsOneWidget);
  }

  Future<void> confirmAlertDialog() async {
    await tester.tap(find.widgetWithText(TextButton, 'Ok'));
    await tester.pumpAndSettle();
  }

  void expectFindWelcomeScreen() {
    expect(
        find.text('Welcome\nto automatic irrigation system'), findsOneWidget);
  }

  Future<void> tapRebootDeviceButton() async {
    await tester.tap(find.widgetWithText(MenuItemButton, 'Reboot IoT device'));
    await tester.pumpAndSettle();
  }

  void expectToCallRebootDeviceMethod() {
    verify(() => mockMqttController.rebootDevice()).called(1);
  }

  Future<void> tapUpdateServerButton() async {
    await tester.tap(find.widgetWithText(MenuItemButton, 'Update server'));
    await tester.pumpAndSettle();
  }

  void expectToCallUpdateServerMethod() {
    verify(() => mockMqttController.updateServer()).called(1);
  }

  Future<void> tapExitButton() async {
    await tester.tap(find.widgetWithText(MenuItemButton, 'Exit'));
    await tester.pumpAndSettle();
  }

  void expectExitTheApp() {
    expect(tester.binding.transientCallbackCount, 0);
  }
}
