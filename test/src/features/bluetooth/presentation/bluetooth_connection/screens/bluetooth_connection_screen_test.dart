import 'package:flutter_test/flutter_test.dart';

import '../../../bluetooth_robot.dart';

void main() {
  testWidgets('bluetooth connection screen when bluetooth is On', (tester) async {
    final r = BluetoothRobot(tester);
    await r.pumpBluetoothConnectionScreen(bluetoothIsOn: true);

    final finder = find.text('IoT Device not found \nor connection with ΙοΤ device lost');
    expect(finder, findsOneWidget);
  });

  testWidgets('bluetooth connection screen when bluetooth is Off', (tester) async {
    final r = BluetoothRobot(tester);
    await r.pumpBluetoothConnectionScreen(bluetoothIsOn: false);

    final finder = find.text('Turn on Bluetooth');
    expect(finder, findsOneWidget);
  });
}
