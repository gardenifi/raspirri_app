import 'package:flutter_test/flutter_test.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/screens/programs_screen.dart';

import '../../../wifi_robot.dart';

void main() {
  group('wifi_connection_screen', () {
    testWidgets('connection success ', (tester) async {
      final r = WifiRobot(tester);

      await r.pumpWifiConnectionScreenWithSuccess('1');
      r.expectConnectionWifiSuccessWidget();
      r.expectFindContinueButton();
      await r.tapContinueToMainScreenButton();
      r.expectNavigateToProgramScreen();
      expect(find.byType(ProgramsScreen), findsOneWidget);
    });

    testWidgets('connection failed ', (tester) async {
      final r = WifiRobot(tester);

      await r.pumpWifiConnectionScreenWithSuccess('2');
      r.expectCouldNotConnectToInternetWidget();
    });

    testWidgets('connection error ', (tester) async {
      final r = WifiRobot(tester);

      await r.pumpWifiConnectionScreenWithError();
      r.expectErrorMessageWidget();
    });
  });
}
// 
 
//