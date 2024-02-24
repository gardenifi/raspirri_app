import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'valve_robot.dart';

void main() {
  final green = Colors.green.withOpacity(0.5);
  const grey = Colors.grey;

  group('AddRemoveValveWidget', () {
    testWidgets('''
      Given that valves 1 and 3 are register
      Then 4 buttons should appear
      And valves 1 and 3 should be green
      And valves 2 and 4 should be gray
      ''', (tester) async {
      final r = ValveRobot(tester);

      await r.openAddRemoveValvesWidget(valves: ['1', '3']);
      r.expectFind2GreyAnd2GreenButtons();
    });

    testWidgets('''
      When tap on button 1
      Then should show AlertDialog
      And if confirm 
      Then should call deleteProgram
      ''', (tester) async {
      final r = ValveRobot(tester);

      await r.openAddRemoveValvesWidget(valves: ['1', '3']);
      await r.tapValveButton(1);
      r.expectFindValveDeletionAlertDialog();
      await r.confirmAlertDialog();
      r.expectToCallDeleteProgramMethod(1);
    });

    testWidgets('''
      Given the valve1 is open
      When tap on button 1
      Then should show AlertDialog
      And if confirm 
      Then dialog close
      ''', (tester) async {
      final r = ValveRobot(tester);

      await r.openAddRemoveValvesWidget(
        valves: ['1', '3'],
        status: {'out1': 1},
      );
      await r.tapValveButton(1);
      r.expectFindValveIsOpenAlertDialog();
    });
  });
}
