import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../features/bluetooth/bluetooth_robot.dart';
import '../mocks.dart';

void main() {
  testWidgets(
    'NoBluetoothWidget',
    (tester) async {
      final r = BluetoothRobot(tester);
      final mockRepository = MockBluetoothRepository();
      final buttonFinder = find.widgetWithText(TextButton, 'Turn on Bluetooth');

      await r.pumpNoBluetoothWidget(mockRepository);
      r.expectFindTurnOnBluetoothButton(buttonFinder);
      await r.tapTurnOnBluetoothButton(buttonFinder, mockRepository);
      r.expectCallingTurnOnBluetoothMethod(mockRepository);
    },
  );
}
