import 'package:flutter_test/flutter_test.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/cycle.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/program.dart';

import '../../create_program_robot.dart';

void main() {
  testWidgets(
    ' delete cycle',
    (tester) async {
      await tester.runAsync(() async {
        final r = CreateProgramRobot(tester);
        final testProgram = Program(
            out: 1, days: 'mon', cycles: [Cycle(start: '10:00', min: '1')], tz_offset: 2);
        await r.pumpCreateProgramScreen(config: [testProgram]);
        r.expectFindCreateProgramScreen();
        r.expectFindOneCycleWidget();
        r.expectCyclesProviderHasOneCycle();
        await r.tapDeleteCycleButton();
        r.expectFindAlertDialog();
        await r.confirmDeleteCycle();
        r.expectCyclesProviderBeEmpty();
      });
    },
  );
}
