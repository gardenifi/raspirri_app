import 'package:flutter_test/flutter_test.dart';

import 'about_robot.dart';

void main() {
  testWidgets('about dialog ...', (tester) async {
    final r = AboutRobot(tester);

    await r.pumpProgramScreen();
    await r.tapMenuButton();
    await r.tapAddAboutButton();
    r.expectFindAboutDialog();
  });
}
