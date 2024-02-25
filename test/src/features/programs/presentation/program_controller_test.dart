import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/cycle.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/program.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/program_controller.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/screens/create_program_screen.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/days_of_week_widget.dart';

import '../../../mocks.dart';
import '../../../provider_container.dart';

void main() {
  group('sendSchedule', () {
    late MockMqttController mockMqttController;
    setUp(() {
      mockMqttController = MockMqttController(const AsyncData(null));
    });
    test('should return 1 when sendMessage is successful', () async {
      // setup
      final container = createContainer(
          overrides: [mqttControllerProvider.overrideWith((ref) => mockMqttController)]);
      final controller = container.read(programProvider);
      final schedule = [
        Program(
            out: 1, days: 'mon', cycles: [Cycle(start: '10:00', min: '1')], tz_offset: 2)
      ];

      when(() => mockMqttController.sendMessage(
          'config', MqttQos.atLeastOnce, jsonEncode(schedule), true)).thenReturn(null);
      // run
      final result = controller.sendSchedule(schedule);
      // verify
      expect(result, 1);
      verify(() => mockMqttController.sendMessage(
          'config', MqttQos.atLeastOnce, jsonEncode(schedule), true)).called(1);
    });

    test('should return -1 when sendMessage fails', () async {
      // setup
      final container = createContainer(
          overrides: [mqttControllerProvider.overrideWith((ref) => mockMqttController)]);
      final controller = container.read(programProvider);
      final schedule = [
        Program(
            out: 1, days: 'mon', cycles: [Cycle(start: '10:00', min: '1')], tz_offset: 2)
      ];
      final exception = Exception('error');

      when(() => mockMqttController.sendMessage(
              'config', MqttQos.atLeastOnce, jsonEncode(schedule), true))
          .thenThrow(exception);
      // run
      final result = controller.sendSchedule(schedule);
      // verify
      expect(result, -1);
      verify(() => mockMqttController.sendMessage(
          'config', MqttQos.atLeastOnce, jsonEncode(schedule), true)).called(1);
    });
  });

  group('deleteProgram', () {
    late MockMqttController mockMqttController;
    setUp(() {
      mockMqttController = MockMqttController(const AsyncData(null));
    });

    test(
        'should remove the program from the schedule, return 2 and send messages to broker',
        () {
      // setup
      final message = jsonEncode({'out': 1, 'cmd': 5});
      final container = createContainer(overrides: [
        configTopicProvider.overrideWith((ref) => [
              Program(
                  out: 1,
                  days: 'mon',
                  cycles: [Cycle(start: '10:00', min: '1')],
                  tz_offset: 2)
            ]),
        mqttControllerProvider.overrideWith((ref) => mockMqttController)
      ]);

      final controller = container.read(programProvider);

      when(() => mockMqttController.sendMessage(
          'config', MqttQos.atLeastOnce, jsonEncode([]), true)).thenReturn(null);

      when(() => mockMqttController.sendMessage(
          'command', MqttQos.atLeastOnce, message, false)).thenReturn(null);
      // run
      final result = controller.deleteProgram(1);
      // verify
      expect(result, 2);
      verify(() => mockMqttController.sendMessage(
          'config', MqttQos.atLeastOnce, jsonEncode([]), true)).called(1);
      verify(() => mockMqttController.sendMessage(
          'command', MqttQos.atLeastOnce, message, false)).called(1);
    });

    test('should return null', () {
      // setup
      final container = createContainer(overrides: [
        configTopicProvider.overrideWith((ref) => [
              Program(
                  out: 1,
                  days: 'mon',
                  cycles: [Cycle(start: '10:00', min: '1')],
                  tz_offset: 2)
            ]),
        mqttControllerProvider.overrideWith((ref) => mockMqttController)
      ]);

      final controller = container.read(programProvider);
      // run
      final result = controller.deleteProgram(2);
      // verify
      expect(result, null);
    });
  });

  group('deleteCycle', () {
    test('should delete the given cycle and update providers', () async {
      // setup
      final container = createContainer(overrides: [
        cyclesOfProgramProvider.overrideWith((ref) => [Cycle(start: '10:00', min: '1')]),
        hasProgramChangedProvider.overrideWith((ref) => false)
      ]);
      final controller = container.read(programProvider);
      // run
      controller.deleteCycle(0);
      // verify
      final expectedCycles = container.read(cyclesOfProgramProvider.notifier).state;
      final expectedHasChanged = container.read(hasProgramChangedProvider.notifier).state;
      expect(expectedCycles, []);
      expect(expectedHasChanged, true);
    });
  });

  group('getProgram', () {
    test('should return the program', () {
      // setup
      final container = createContainer();
      final testProgram = Program(out: 1, days: 'mon', cycles: [], tz_offset: 2);
      final schedule = [testProgram];
      final controller = container.read(programProvider);
      // run
      final result = controller.getProgram(schedule, 1);
      // verify
      expect(result, testProgram);
    });

    test('should return null', () {
      // setup
      final container = createContainer();
      final testProgram = Program(out: 1, days: 'mon', cycles: [], tz_offset: 2);
      final schedule = [testProgram];
      final controller = container.read(programProvider);
      // run
      final result = controller.getProgram(schedule, 2);
      // verify
      expect(result, null);
    });
  });

  group('getDays', () {
    test('should return day in DaysOfWeek format', () {
      // setup
      final container = createContainer();
      final testProgram = Program(out: 1, days: 'mon', cycles: [], tz_offset: 2);
      final schedule = [testProgram];
      final controller = container.read(programProvider);
      // run
      final result = controller.getDays(schedule, 1);
      // verify
      expect(result, [DaysOfWeek.Mon]);
    });

    test('should return empty list', () {
      // setup
      final container = createContainer();
      final testProgram = Program(out: 1, days: 'mon', cycles: [], tz_offset: 2);
      final schedule = [testProgram];
      final controller = container.read(programProvider);
      // run
      final result = controller.getDays(schedule, 2);
      // verify
      expect(result, []);
    });
  });

  test('getTimesAsMap returs a map', () {
    // setup
    final container = createContainer();
    final controller = container.read(programProvider);
    final testCycle1 = Cycle(start: '10:00', min: '1');
    final testCycle2 = Cycle(start: '23:00', min: '65');
    // run
    final result1 = controller.getTimesAsMap([testCycle1]);
    final result2 = controller.getTimesAsMap([testCycle2]);
    // verify
    final expected1 = [
      {'start': '10:00', 'end': '10:01'}
    ];
    final expected2 = [
      {'start': '23:00', 'end': '00:05'}
    ];
    expect(result1, expected1);
    expect(result2, expected2);
  });

  test('getStartTimesAsString returs a String', () {
    // setup
    final container = createContainer();
    final controller = container.read(programProvider);
    final testCycleMap = {'start': '10:00', 'end': '10:01'};
    // run
    final result = controller.getStartTimesAsString([testCycleMap]);
    // verify
    const expected = '10:00';
    expect(result, expected);
  });
}
