import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/cycle.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/program.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/days_of_week_widget.dart';

import '../../create_program_robot.dart';

void main() {
  final testProgram = Program(
      out: 1, days: 'mon', cycles: [Cycle(start: '10:00', min: '1')], tz_offset: 2);

  void setLandscapeScreen(WidgetTester tester) {
    final dpi = tester.view.devicePixelRatio = 3;
    tester.view.physicalSize = Size(800 * dpi, 360 * dpi);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  void setPortraitScreen(WidgetTester tester) {
    final dpi = tester.view.devicePixelRatio;
    tester.view.physicalSize = Size(360 * dpi, 800 * dpi);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  group(
    'Portrait mode',
    () {
      testWidgets('should open CreateProgramScreen in portait mode', (tester) async {
        final r = CreateProgramRobot(tester);
        setPortraitScreen(tester);
        await r.pumpCreateProgramScreen(config: [testProgram]);
        r.expectFindDaysOfWeekWidget();
        r.expectFindEditNameIconButton();
      });

      testWidgets(
        '''
        When no changes made 
        Then the SaveButton should NOT appear
        ''',
        (tester) async {
          final r = CreateProgramRobot(tester);
          setPortraitScreen(tester);
          await r.pumpCreateProgramScreen();
          r.expectFindDaysOfWeekWidget();
          r.expectNotFindSaveProgramButton();
        },
      );

      testWidgets(
        '''
        When changes made 
        Then the SaveButton should appear
        ''',
        (tester) async {
          final r = CreateProgramRobot(tester);
          setPortraitScreen(tester);
          await r.pumpCreateProgramScreen(hasChanged: true);
          r.expectFindDaysOfWeekWidget();
          r.expectFindSaveProgramButton();
        },
      );

      testWidgets(
        '''
        When exists program 
        Then DeleteProgramButton should appear
        ''',
        (tester) async {
          final r = CreateProgramRobot(tester);
          setPortraitScreen(tester);
          await r.pumpCreateProgramScreen(config: [testProgram]);
          r.expectFindDaysOfWeekWidget();
          r.expectFindDeleteProgramButton();
        },
      );

      testWidgets(
        '''
        When NOT exists a program 
        Then DeleteProgramButton should NOT appear
        ''',
        (tester) async {
          final r = CreateProgramRobot(tester);
          setPortraitScreen(tester);
          await r.pumpCreateProgramScreen(config: []);
          r.expectFindDaysOfWeekWidget();
          r.expectNotFindDeleteProgramButton();
        },
      );

      testWidgets(
        '''
        When tap on edit name IconButton
        Then TextField should appear
        And When enter a name in TextField
        Then Save button should appear
        And provider should update
        ''',
        (tester) async {
          final r = CreateProgramRobot(tester);
          setPortraitScreen(tester);
          await r.pumpCreateProgramScreen(config: []);
          r.expectNotFindTextField();
          await r.tapEditNameIconButton();
          r.expectFindTextField();
          await r.enterTextToTextField();
          r.expectFindSaveProgramButton();
          r.expectHasProgramChangedProviderUpdated();
        },
      );

      testWidgets(
        '''
        When tap on a day button (Mon)
        Then AddCycleButton should appear
        And the color of day button to be green
        And daysOfProgramProvider should update
        And AddCycleButton should appear
        ''',
        (tester) async {
          final r = CreateProgramRobot(tester);
          setPortraitScreen(tester);
          await r.pumpCreateProgramScreen(config: []);
          r.expectFindDaysOfWeekWidget();
          r.expectFindSevenDayButtons();
          // before tap the dayButton color must be null (gray)
          r.expectDayButtonColor('Mon', null);
          await r.tapDayButton('Mon');
          // after tap the dayButton color must be green
          r.expectDayButtonColor('Mon', Colors.green[400]);
          r.expectDaysOfProgramProviderUpdated([DaysOfWeek.Mon]);
          r.expectFindAddCycleButton();
        },
      );

      testWidgets(
        '''
        Given a DayButton (Mon) is selected
        When tap on tha DayButton again 
        Then the color of day button should be null
        And daysOfProgramProvider should update
        ''',
        (tester) async {
          final r = CreateProgramRobot(tester);
          setPortraitScreen(tester);
          await r.pumpCreateProgramScreen(config: [testProgram]);
          r.expectFindSevenDayButtons();
          // before tap the dayButton color must be green
          r.expectDayButtonColor('Mon', Colors.green[400]);
          await r.tapDayButton('Mon');
          // after tap the dayButton color must be null
          r.expectDayButtonColor('Mon', null);
          r.expectDaysOfProgramProviderUpdated([]);
        },
      );
    },
  );

  group(
    'Landcsape mode',
    () {
      testWidgets('should open CreateProgramScreen in landscape mode', (tester) async {
        final r = CreateProgramRobot(tester);
        setLandscapeScreen(tester);
        await r.pumpCreateProgramScreen(config: [testProgram]);
        r.expectFindDaysOfWeekWidget();
        r.expectFindEditNameIconButton();
      });

      testWidgets(
        '''
        When no changes made 
        Then the SaveButton should NOT appear
        ''',
        (tester) async {
          final r = CreateProgramRobot(tester);
          setLandscapeScreen(tester);
          await r.pumpCreateProgramScreen();
          r.expectFindDaysOfWeekWidget();
          r.expectNotFindSaveProgramButton();
        },
      );

      testWidgets(
        '''
        When changes made 
        Then the SaveButton should appear
        ''',
        (tester) async {
          final r = CreateProgramRobot(tester);
          setLandscapeScreen(tester);
          await r.pumpCreateProgramScreen(hasChanged: true);
          r.expectFindDaysOfWeekWidget();
          r.expectFindSaveProgramButton();
        },
      );

      testWidgets(
        '''
        When exists program 
        Then DeleteProgramButton should appear
        ''',
        (tester) async {
          final r = CreateProgramRobot(tester);
          setLandscapeScreen(tester);
          await r.pumpCreateProgramScreen(config: [testProgram]);
          r.expectFindDaysOfWeekWidget();
          r.expectFindDeleteProgramButton();
        },
      );

      testWidgets(
        '''
        When NOT exists a program 
        Then DeleteProgramButton should NOT appear
        ''',
        (tester) async {
          final r = CreateProgramRobot(tester);
          setLandscapeScreen(tester);
          await r.pumpCreateProgramScreen(config: []);
          r.expectFindDaysOfWeekWidget();
          r.expectNotFindDeleteProgramButton();
        },
      );

      testWidgets(
        '''
        When tap on edit name IconButton
        Then TextField should appear
        And When enter a name in TextField
        Then Save button should appear
        And provider should update
        ''',
        (tester) async {
          final r = CreateProgramRobot(tester);
          setLandscapeScreen(tester);
          await r.pumpCreateProgramScreen(config: []);
          r.expectNotFindTextField();
          await r.tapEditNameIconButton();
          r.expectFindTextField();
          await r.enterTextToTextField();
          r.expectFindSaveProgramButton();
          r.expectHasProgramChangedProviderUpdated();
        },
      );

      testWidgets(
        '''
        When tap on a day button (Mon)
        Then AddCycleButton should appear
        And the color of day button to be green
        And daysOfProgramProvider should update
        And AddCycleButton should appear
        ''',
        (tester) async {
          final r = CreateProgramRobot(tester);
          setLandscapeScreen(tester);
          await r.pumpCreateProgramScreen(config: []);
          r.expectFindDaysOfWeekWidget();
          r.expectFindSevenDayButtons();
          // before tap the dayButton color must be null (gray)
          r.expectDayButtonColor('Mon', null);
          await r.tapDayButton('Mon');
          // after tap the dayButton color must be green
          r.expectDayButtonColor('Mon', Colors.green[400]);
          r.expectDaysOfProgramProviderUpdated([DaysOfWeek.Mon]);
          r.expectFindAddCycleButton();
        },
      );

      testWidgets(
        '''
        Given a DayButton (Mon) is selected
        When tap on tha DayButton again 
        Then the color of day button should be null
        And daysOfProgramProvider should update
        ''',
        (tester) async {
          final r = CreateProgramRobot(tester);
          setLandscapeScreen(tester);
          await r.pumpCreateProgramScreen(config: [testProgram]);
          r.expectFindSevenDayButtons();
          // before tap the dayButton color must be green
          r.expectDayButtonColor('Mon', Colors.green[400]);
          await r.tapDayButton('Mon');
          // after tap the dayButton color must be null
          r.expectDayButtonColor('Mon', null);
          r.expectDaysOfProgramProviderUpdated([]);
        },
      );
    },
  );

  testWidgets(
    '''
    Given the CreateProgramScreen is open
    And changes made
    When tap the back button
    Then an AlertDialog should appear
    And When tap 'Yes'
    Then pop and go back to ProgramScreen
    ''',
    (tester) async {
      final r = CreateProgramRobot(tester);
      setPortraitScreen(tester);
      await r.pumpCreateProgramScreen(hasChanged: true);
      r.expectFindCreateProgramScreen();
      await r.tapBackButton();
      r.expectNotFindCreateProgramScreen();
    },
  );

  testWidgets(
    'Add new cycle flow',
    (tester) async {
      final r = CreateProgramRobot(tester);
      setPortraitScreen(tester);
      await r.pumpCreateProgramScreen(config: []);
      await r.tapDayButton('Mon');
      r.expectFindAddCycleButton();
      await r.tapAddCyclebutton();
      r.expectFindTimePicker();
      await r.confirmSelectTime();
      r.expectFindDurationPicker();
      await r.confirmDuration();
      r.expectCyclesProviderUpdated();
    },
  );

  testWidgets(
    '''
    Given the CreateProgramScreen is open
    And there are cycles
    When tap the start button
    Then TimePicker should apear
    And When tap the duration button
    Then DurationPicker should appear
    ''',
    (tester) async {
      await tester.runAsync(() async {
        final r = CreateProgramRobot(tester);
        setPortraitScreen(tester);
        await r.pumpCreateProgramScreen(config: [testProgram]);
        r.expectFindCreateProgramScreen();
        r.expectFindOneCycleWidget();
        await r.tapStartTimeButton();
        r.expectFindTimePicker();
        await r.tapStartTimeButton();
        await r.confirmSelectTime();
        await r.tapDurationButton();
        await r.confirmDuration();
      });
    },
  );

  
}
