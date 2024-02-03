import 'package:flutter_test/flutter_test.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/cycle.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/program.dart';

void main() {
  group('Program model', () {
    test('Program.fromJson should return an instance of Program from a json', () {
      // setup
      const Map<String, dynamic> json = {
        "out": 1,
        "name": "Valve 1",
        "days": "wed,fri,sat",
        "cycles": [
          {"start": "15:09", "min": "1"},
          {"start": "21:36", "min": "1"}
        ],
        "tz_offset": 2
      };
      // run
      final program = Program.fromJson(json);
      // verify
      final expected = Program(
          out: 1,
          name: 'Valve 1',
          days: "wed,fri,sat",
          cycles: [Cycle(start: "15:09", min: "1"), Cycle(start: "21:36", min: '1')],
          tz_offset: 2);
      expect(program, expected);
    });

    test('Program.fromJson should throw exception if [out] in json is not of type [int]',
        () {
      // setup
      const Map<String, dynamic> json = {
        "out": "1",
        "name": "Valve 1",
        "days": "wed,fri,sat",
        "cycles": [
          {"start": "15:09", "min": "1"},
          {"start": "21:36", "min": "1"}
        ],
        "tz_offset": 2
      };
      // verify
      expect(() => Program.fromJson(json), throwsException);
    });

    test(
        'Program.fromJson should throw exception if [days] in json is not of type [String]',
        () {
      // setup
      const Map<String, dynamic> json = {
        "out": 1,
        "name": "Valve 1",
        "days": 12,
        "cycles": [
          {"start": "15:09", "min": "1"},
          {"start": "21:36", "min": "1"}
        ],
        "tz_offset": 2
      };
      // verify
      expect(() => Program.fromJson(json), throwsException);
    });

    test(
        'Program.fromJson should throw exception if [tz_offset] in json is not of type [int]',
        () {
      // setup
      const Map<String, dynamic> json = {
        "out": 1,
        "name": "Valve 1",
        "days": "wed,fri,sat",
        "cycles": [
          {"start": "15:09", "min": "1"},
          {"start": "21:36", "min": "1"}
        ],
        "tz_offset": "2"
      };
      // verify
      expect(() => Program.fromJson(json), throwsException);
    });
  });

  test('toJson should convert a Program to json', () {
    // setup
    final program = Program(
        out: 1,
        name: 'Valve 1',
        days: 'fri',
        cycles: [Cycle(start: '10:00', min: '1')],
        tz_offset: 2);
    // run
    final json = program.toJson();
    // verify
    final Map<String, dynamic> expected = {
      'out': 1,
      'name': 'Valve 1',
      'days': 'fri',
      'cycles': [Cycle(start: '10:00', min: '1').toJson()],
      'tz_offset': 2,
    };
    expect(json, expected);
  });

  test('toString should return a string formated representation of Program', () {
    // setup
    final program = Program(
        out: 1,
        name: 'Valve 1',
        days: 'fri',
        cycles: [Cycle(start: '10:00', min: '1')],
        tz_offset: 2);
    // run
    final programToString = program.toString();
    // verify
    const expected =
        'Program(out: 1, name: Valve 1, days: fri, cycles: [Cycle(start: 10:00, min: 1)], tz_offset: 2)';
    expect(programToString, expected);
  });

  test('hashCode should be the XOR of start and min hashCodes', () {
    // setup
    final Program instance = Program(
        out: 1,
        name: 'Valve 1',
        days: 'fri',
        cycles: [Cycle(start: '10:00', min: '1')],
        tz_offset: 2);
    // run
    final int hashCode = instance.hashCode;
    // verify
    expect(
        hashCode,
        equals(instance.out.hashCode ^
            instance.name.hashCode ^
            instance.days.hashCode ^
            instance.cycles.hashCode ^
            instance.tz_offset.hashCode));
  });
}
