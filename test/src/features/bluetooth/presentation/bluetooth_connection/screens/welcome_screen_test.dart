import 'package:flutter_test/flutter_test.dart';

import '../../../bluetooth_robot.dart';

void main() {
  testWidgets(
    '''Given device has not been initialized
      And bluetooth adapter is on
      Then open Welcome screen with Connection Button enabled''',
    (tester) async {
      final r = BluetoothRobot(tester);
      await r.pumpWelcomeScreen(isBluetoothOn: true, deviceHasBeenInitialized: false);
      r.expectFoundTextButton(false);
      r.expectButtonIsEnabled(true);
    },
  );

  testWidgets(
    '''Given device has not been initialized
      And bluetooth adapter is off
      Then open Welcome screen with No bluetooth message
      And connection button disabled''',
    (tester) async {
      final r = BluetoothRobot(tester);
      await r.pumpWelcomeScreen(isBluetoothOn: false, deviceHasBeenInitialized: false);
      r.expectFoundTextButton(true);
      r.expectButtonIsEnabled(false);
    },
  );

  
}
