import 'package:flutter_test/flutter_test.dart';

import 'menu_button_robot.dart';

void main() {
  group('MoreMenuButton', () {
    testWidgets('Add/Remove valves', (tester) async {
      final r = MenuButtonRobot(tester);
      await r.pumpProgramScreen();
      r.expectFindMenuButton();
      await r.tapMenuButton();
      r.expectFindAddRemoveValvesMenuItemButton();
      await r.tapAddRemoveValvesButton();
      r.expectFind4AddRemoveValveWidgets();
    });

    testWidgets('Initialize IoT device', (tester) async {
      final r = MenuButtonRobot(tester);
      await r.pumpProgramScreen();
      r.expectFindMenuButton();
      await r.tapMenuButton();
      await r.tapInitializeDeviceButton();
      r.expectFindAlertDialog();
      await r.confirmAlertDialog();
      r.expectFindWelcomeScreen();
    });

    testWidgets('Reboot IoT device', (tester) async {
      final r = MenuButtonRobot(tester);
      await r.pumpProgramScreen();
      r.expectFindMenuButton();
      await r.tapMenuButton();
      await r.tapRebootDeviceButton();
      r.expectFindAlertDialog();
      await r.confirmAlertDialog();
      r.expectToCallRebootDeviceMethod();
    });

    testWidgets('Update server', (tester) async {
      final r = MenuButtonRobot(tester);
      await r.pumpProgramScreen();
      r.expectFindMenuButton();
      await r.tapMenuButton();
      await r.tapUpdateServerButton();
      r.expectFindAlertDialog();
      await r.confirmAlertDialog();
      r.expectToCallUpdateServerMethod();
    });

    testWidgets('Exit', (tester) async {
      final r = MenuButtonRobot(tester);
      await r.pumpProgramScreen();
      r.expectFindMenuButton();
      await r.tapMenuButton();
      await r.tapExitButton();
      r.expectFindAlertDialog();
      await r.confirmAlertDialog();
      r.expectExitTheApp();
    });
  });
}
