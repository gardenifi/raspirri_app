import 'package:flutter_test/flutter_test.dart';

import '../../../../robot.dart';

void main() {
  testWidgets(
    '''
    Given the app has been initialized
    When program screen opens
    And is fetching data from broker
    Then a CircularProgressIndicator must show
    ''',
    (tester) async {
      final r = Robot(tester: tester);
      await r.openProgramScreen(true, false);
      r.expectFindCircularProgressIndicator();
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

   testWidgets(
    '''
    Given the app has been initialized
    When program screen opens
    And fetching data from broker returns error
    Then a Center widget with text error must show
    ''',
    (tester) async {
      final r = Robot(tester: tester);
      await r.openProgramScreen(false, true);
      r.expectFindError();
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  testWidgets(
    '''
    Given the app has been initialized
    When program screen opens
    And has fetched data from broker
    And has 3 valves registered
    Then 3 ListTiles must show
    ''',
    (tester) async {
      final r = Robot(tester: tester);
      await r.openProgramScreen(false, false);
      r.expectFindThreeListTiles();
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );

  testWidgets(
    'Open Edit/View Program Screen',
    (tester) async {
      final r = Robot(tester: tester);
      await r.openProgramScreen(false, false);
      r.openEditProgramScreen();
    },
    timeout: const Timeout(Duration(seconds: 1)),
  );
}
