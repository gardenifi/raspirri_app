import 'package:flutter_test/flutter_test.dart';

import '../../../programs/program_robot.dart';

void main() {
  testWidgets('disconnected from broker widget ...', (tester) async {
    final r = ProgramRobot(tester);
    await r.pumpProgramScreen(disconnected: true);
    r.expectFindDisconnectedFromBroker();
    r.expectFindExitTextButton();
    await r.tapExitButton();
    r.expectAppExited();
  });
}
