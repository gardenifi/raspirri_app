
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/widgets/can_not_connect_to_broker_widget.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/widgets/device_disconnected.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/widgets/disconnected_from_broker_widget.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/screens/programs_screen.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/no_valves_widget.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/valves_widget.dart';

import '../../mocks.dart';

class ProgramRobot {
  ProgramRobot(this.tester);
  final WidgetTester tester;

  Future<void> pumpProgramScreen({
    bool doPumpAndSettle = true,
    AsyncValue<void> controllerValue = const AsyncData(null),
    bool cantConnect = false,
    Map<String, dynamic> statusValue = const {},
    List<String> valvesList = const ['1'],
    bool disconnected = false,
  }) async {
    final mockMqttController = MockMqttController(controllerValue);

    when(() => mockMqttController.setupAndConnectClient())
        .thenAnswer((_) => Future.value());

    // when(() => mockMqttController.dispose()).thenReturn(null);

    await tester.pumpWidget(ProviderScope(
        overrides: [
          // wifiConnectionStatusProvider.overrideWith((ref) => '1'),
          mqttControllerProvider.overrideWith((ref) => mockMqttController),
          valvesTopicProvider.overrideWith((ref) => valvesList),
          statusTopicProvider.overrideWith((ref) => statusValue),
          cantConnectProvider.overrideWith((ref) => cantConnect),
          disconnectedProvider.overrideWith((ref) => disconnected),
          connectedProvider.overrideWith((ref) => false)
        ],
        child: const MaterialApp(
          home: ProgramsScreen(),
        )));

    if (doPumpAndSettle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
  }

  void expectFindCircularProgressIndicator() {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  void expectFindErrorCenterWidget() {
    expect(find.widgetWithText(Center, 'An error'), findsOneWidget);
  }

  void expectFindCanNotConnectToBrokerWidget() {
    expect(find.byType(CanNotConnectToBrokerWidget), findsOneWidget);
  }

  void expectFindDeviceDisconnectedWidget() {
    expect(find.byType(DeviceDisconnectedWidget), findsOneWidget);
  }

  void expectFindNoValvesWidget() {
    expect(find.byType(NoValvesWidget), findsOneWidget);
  }

  void expectFindDisconnectedFromBroker() {
    expect(find.byType(DisconnectedFromBrokerWidget), findsOneWidget);
  }

  void expectFindValvesWidget() {
    expect(find.byType(ValvesWidget), findsOneWidget);
  }

  void expectFindExitTextButton() {
    expect(find.widgetWithText(TextButton, 'Exit'), findsOneWidget);
  }

  Future<void> tapExitButton() async {
    final finder = find.widgetWithText(TextButton, 'Exit');
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  void expectAppExited() {
    expect(tester.binding.transientCallbackCount, 0);
  }

  void expectFindTryAgainButton() {
    expect(find.widgetWithText(TextButton, 'Try again'), findsOneWidget);
  }

  Future<void> tapTryAgainButton() async {
    final finder = find.widgetWithText(TextButton, 'Try again');
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }
}
