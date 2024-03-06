import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:new_gardenifi_app/src/common_widgets/menu_button.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/program_controller.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/screens/programs_screen.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/add_remove_valve_widget.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/days_of_week_widget.dart';

import '../../../../mocks.dart';

class ValveRobot {
  ValveRobot(this.tester);
  final WidgetTester tester;

  late ProviderContainer container;
  late MockMqttController mockMqttController;
  late MockProgramController mockProgramController;

  Future<void> pumpProgramScreen({
    bool doPumpAndSettle = true,
    AsyncValue<void> controllerValue = const AsyncData(null),
    bool cantConnect = false,
    Map<String, dynamic> statusValue = const {},
    List<String> valvesList = const [],
    bool disconnected = false,
  }) async {
    registerFallbackValue(DaysOfWeek);
    registerFallbackValue(MqttQos.atLeastOnce);
    mockMqttController = MockMqttController(controllerValue);
    mockProgramController = MockProgramController();

    when(() => mockMqttController.setupAndConnectClient())
        .thenAnswer((_) => Future.value());

    when(() => mockMqttController.sendMessage(
          any(),
          any(),
          any(),
          any(),
        )).thenReturn(null);

    when(() => mockProgramController.deleteProgram(any())).thenReturn(null);
    when(() => mockProgramController.getStartTimesAsString(any()))
        .thenReturn('');
    when(() => mockProgramController.getNextRun(any(), any())).thenReturn('');

    await tester.pumpWidget(ProviderScope(
        overrides: [
          mqttControllerProvider.overrideWith((ref) => mockMqttController),
          valvesTopicProvider.overrideWith((ref) => valvesList),
          statusTopicProvider.overrideWith((ref) => statusValue),
          cantConnectProvider.overrideWith((ref) => cantConnect),
          disconnectedProvider.overrideWith((ref) => disconnected),
          connectedProvider.overrideWith((ref) => true),
          programProvider.overrideWith((ref) => mockProgramController)
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

  Future<void> openAddRemoveValvesWidget(
      {List<String> valves = const [],
      Map<String, dynamic> status = const {}}) async {
    await pumpProgramScreen(valvesList: valves, statusValue: status);
    await tapMenuButton();
    await tapAddRemoveValvesButton();
    expectFind4AddRemoveValveWidgets();
  }

  Future<void> tapMenuButton() async {
    await tester.tap(find.byType(MoreMenuButton));
    await tester.pumpAndSettle();
  }

  Future<void> tapAddRemoveValvesButton() async {
    await tester.tap(find.widgetWithText(MenuItemButton, 'Add/Remove valves'));
    await tester.pumpAndSettle();
  }

  Future<void> tapValveButton(int valve) async {
    await tester.tap(find.text(valve.toString()));
    await tester.pumpAndSettle();
  }

  void expectFindValveDeletionAlertDialog() {
    expect(find.text('Valve deletion'), findsOneWidget);
  }

  void expectFindValveIsOpenAlertDialog() {
    expect(find.text('Valve is on!'), findsOneWidget);
  }

  Future<void> confirmAlertDialog() async {
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
  }

  void expectToCallDeleteProgramMethod(int valve) {
    verify(() => mockProgramController.deleteProgram(1)).called(1);
  }

  void expectFindAddRemoveValvesMenuItemButton() {
    expect(find.widgetWithText(MenuItemButton, 'Add/Remove valves'),
        findsOneWidget);
  }

  void expectFind4AddRemoveValveWidgets() {
    expect(find.byType(AddRemoveValveWidget), findsNWidgets(4));
  }

  void expectFind2GreyAnd2GreenButtons() {
    for (int i = 1; i < 5; i++) {
      final finder = find.byType(FloatingActionButton);
      final button =
          finder.evaluate().elementAt(i - 1).widget as FloatingActionButton;
      expect(find.text(i.toString()), findsOneWidget);
      if (i == 1 || i == 3) {
        expect(button.backgroundColor, Colors.grey);
      } else {
        expect(button.backgroundColor, Colors.green.withOpacity(0.5));
      }
    }
  }
}
