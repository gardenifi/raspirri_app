import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_gardenifi_app/src/common_widgets/menu_button.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/screens/programs_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../mocks.dart';

class AboutRobot {
  AboutRobot(this.tester);
  final WidgetTester tester;

  Future<void> pumpProgramScreen({
    bool doPumpAndSettle = true,
    AsyncValue<void> controllerValue = const AsyncData(null),
    bool cantConnect = false,
    Map<String, dynamic> statusValue = const {},
    List<String> valvesList = const [],
    bool disconnected = false,
  }) async {
    PackageInfo.setMockInitialValues(
        appName: 'appName',
        packageName: 'packageName',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: 'buildSignature');
    SharedPreferences.setMockInitialValues({
      'hwId': '1234',
    });
    var mockMqttController = MockMqttController(controllerValue);

    when(() => mockMqttController.setupAndConnectClient())
        .thenAnswer((_) => Future.value());

    await tester.pumpWidget(ProviderScope(
        overrides: [
          mqttControllerProvider.overrideWith((ref) => mockMqttController),
          valvesTopicProvider.overrideWith((ref) => valvesList),
          statusTopicProvider.overrideWith((ref) => statusValue),
          cantConnectProvider.overrideWith((ref) => cantConnect),
          disconnectedProvider.overrideWith((ref) => disconnected),
          connectedProvider.overrideWith((ref) => true),
          metadataTopicProvider.overrideWith((ref) => {
                'ip_address': '192.168.1.1',
                'uptime': 'up 5 days',
                'git_commit': '123456'
              })
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

  Future<void> tapMenuButton() async {
    await tester.tap(find.byType(MoreMenuButton));
    await tester.pumpAndSettle();
  }

  Future<void> tapAddAboutButton() async {
    await tester.tap(find.widgetWithText(MenuItemButton, 'About'));
    await tester.pumpAndSettle();
  }

  void expectFindAboutDialog() {
    expect(find.text('RaspirriV1'), findsOneWidget);
    expect(find.text('Hardware Id: 1234\n'), findsOneWidget);
  }
}
