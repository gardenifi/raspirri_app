import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/cycle.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/days_of_week_widget.dart';
import 'package:new_gardenifi_app/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  group('utils', () {
    test('check SharedPreferences key and return true', () async {
      // setup
      SharedPreferences.setMockInitialValues({'initialized': true});
      // run
      final result = await checkInitializationStatus();
      //verify
      expect(result, true);
    });

    test('check SharedPreferences key and return false', () async {
      // setup
      SharedPreferences.setMockInitialValues({'initialized': false});
      // run
      final result = await checkInitializationStatus();
      //verify
      expect(result, false);
    });

    test('convertStringToTimeOfDay takes a String time and return a TimeOfDay', () {
      // setup
      const testTime = '10:00';
      const expected = TimeOfDay(hour: 10, minute: 0);
      // run
      final result = convertStringToTimeOfDay(testTime);
      // verify
      expect(expected, result);
    });

    test('addCycleAndSortList', () {
      // setup
      final List<Cycle> cycles = [
        Cycle(start: '10:15', min: '10'),
        Cycle(start: '15:00', min: '5')
      ];
      final Cycle newCycle = Cycle(start: '12:00', min: '5');
      final expecting = [
        Cycle(start: '10:15', min: '10'),
        Cycle(start: '12:00', min: '5'),
        Cycle(start: '15:00', min: '5')
      ];
      // run
      final result = addCycleAndSortList(cycles, newCycle);
      // verify
      expect(result, expecting);
    });

    test('toDecapitalized', () {
      const text = 'Monday';
      final result = text.toDecapitalized();
      expect(result, 'monday');
    });

    test('stringToDaysOfWeek takes a string and returns List of DaysOfWeek', () {
      // setup
      const days = 'mon,tue,wed,thu,fri,sat,sun';
      final expecting = [
        DaysOfWeek.Mon,
        DaysOfWeek.Tue,
        DaysOfWeek.Wed,
        DaysOfWeek.Thu,
        DaysOfWeek.Fri,
        DaysOfWeek.Sat,
        DaysOfWeek.Sun
      ];
      // run
      final result = stringToDaysOfWeek(days);
      // verify
      expect(result, expecting);
    });

    group('todayToDaysOfWeek take a string and returns DaysOfWeek', () {
      test(' checking Mon', () {
        // setup
        const dayToString = 'Mon';
        const expecting = DaysOfWeek.Mon;
        // run
        final result = todayToDaysOfWeek(dayToString);
        // verify
        expect(result, expecting);
      });
      test(' checking Tue', () {
        // setup
        const dayToString = 'Tue';
        const expecting = DaysOfWeek.Tue;
        // run
        final result = todayToDaysOfWeek(dayToString);
        // verify
        expect(result, expecting);
      });
      test(' checking Wed', () {
        // setup
        const dayToString = 'Wed';
        const expecting = DaysOfWeek.Wed;
        // run
        final result = todayToDaysOfWeek(dayToString);
        // verify
        expect(result, expecting);
      });
      test(' checking Thu', () {
        // setup
        const dayToString = 'Thu';
        const expecting = DaysOfWeek.Thu;
        // run
        final result = todayToDaysOfWeek(dayToString);
        // verify
        expect(result, expecting);
      });
      test(' checking Fri', () {
        // setup
        const dayToString = 'Fri';
        const expecting = DaysOfWeek.Fri;
        // run
        final result = todayToDaysOfWeek(dayToString);
        // verify
        expect(result, expecting);
      });
      test(' checking Sat', () {
        // setup
        const dayToString = 'Sat';
        const expecting = DaysOfWeek.Sat;
        // run
        final result = todayToDaysOfWeek(dayToString);
        // verify
        expect(result, expecting);
      });
      test(' checking Sun', () {
        // setup
        const dayToString = 'Sun';
        const expecting = DaysOfWeek.Sun;
        // run
        final result = todayToDaysOfWeek(dayToString);
        // verify
        expect(result, expecting);
      });
    });

    test(
      'convertListDaysOfWeekToListString takes a list of DaysOfWeek and return a list of String',
      () {
        // setup
        final listOfDaysOfWeek = [DaysOfWeek.Mon, DaysOfWeek.Fri];
        const expecting = ['mon', 'fri'];
        // run
        final result = convertListDaysOfWeekToListString(listOfDaysOfWeek);
        // verify
        expect(expecting, result);
      },
    );

    test('timeIsAfterNow takes a String time before current time and returns false', () {
      // setup
      const testTime = '00:00';
      // run
      final result = timeIsAfterNow(testTime);
      // verify
      expect(result, false);
    });

    test('timeIsAfterNow takes a String time after current time and returns true', () {
      // setup
      const testTime = '23:59';
      // run
      final result = timeIsAfterNow(testTime);
      // verify
      expect(result, true);
    });
  });
}