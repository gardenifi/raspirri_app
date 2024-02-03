import 'package:flutter_test/flutter_test.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/cycle.dart';

void main() {
  group('Cycle model', () {
    test('Cycle.fromJson should create an instance of Cycle from a json', () {
      // setup
      final Map<String, dynamic> json = {
        'start': '10:00',
        'min': '1',
      };
      // run
      final cycle = Cycle.fromJson(json);
      // verify
      final expected = Cycle(start: '10:00', min: '1');
      expect(cycle, expected);
    });

    test('Cycle.fromJson should throw Exception if [start] is not of type [String]', () {
      // setup
      final Map<String, dynamic> json = {
        'start': 1,
        'min': '1',
      };
      // verify
      expect(()=> Cycle.fromJson(json), throwsException);
      // verify
      // final expected = Cycle(start: '10:00', min: '1');
    });

    test('toJson should convert Cycle to json', () {
      final cycle = Cycle(start: '10:00', min: '1');
      // run
      final json = cycle.toJson();
      // verify
      final expected = {
        'start': '10:00',
        'min': '1',
      };
      expect(json, expected);
    });

    test('copyWith should return a Cycle with updated startTime', () {
      final cycle = Cycle(start: '10:00', min: '1');
      // run
      final newCycle = cycle.copyWith(startTime: '12:00');
      // verify
      final expected = Cycle(start: '12:00', min: '1');
      expect(newCycle, expected);
    });

    test('copyWith should return a Cycle with updated duration', () {
      // setup
      final cycle = Cycle(start: '10:00', min: '1');
      // run
      final newCycle = cycle.copyWith(duration: '15');
      // verify
      final expected = Cycle(start: '10:00', min: '15');
      expect(newCycle, expected);
    });

    test('toString should return a string formated representation of Cycle', () {
      // setup
      final cycle = Cycle(start: '10:00', min: '1');
      // run
      final cycleToString = cycle.toString();
      // verify
      const expected = 'Cycle(start: 10:00, min: 1)';
      expect(cycleToString, expected);
    });

    test('hashCode should be the XOR of start and min hashCodes', () {
      // setup
      final Cycle instance = Cycle(start: '10:00', min: '10');
      // run
      final int hashCode = instance.hashCode;
      // verify
      expect(hashCode, equals(instance.start.hashCode ^ instance.min.hashCode));
    });
  });
}
