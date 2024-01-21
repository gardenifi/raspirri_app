import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:new_gardenifi_app/src/constants/mqtt_constants.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/cycle.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/program.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/screens/create_program_screen.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/days_of_week_widget.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';
import 'package:new_gardenifi_app/utils.dart';

class ProgramController {
  ProgramController(this.ref);
  final Ref ref;

  int sendSchedule(List<Program> schedule) {
    try {
      var scheduleEncoded = jsonEncode(schedule);
      ref
          .read(mqttControllerProvider.notifier)
          .sendMessage(configTopic, MqttQos.atLeastOnce, scheduleEncoded, true);
      return 1;
    } catch (e) {
      return -1;
    }
  }

  int? deleteProgram(int valve) {
    var deleteCmd = {'out': valve, 'cmd': 5};
    var schedule = ref.read(configTopicProvider);
    var index = schedule.indexWhere(
      (program) => program.out == valve,
    );
    if (index != -1) {
      schedule.removeAt(index);
      sendSchedule(schedule);
      ref
          .read(mqttControllerProvider.notifier)
          .sendMessage(commandTopic, MqttQos.atLeastOnce, jsonEncode(deleteCmd), false);
      return 2;
    }
    return null;
  }

  void deleteCycle(int cycleIndex) {
    var cycles = ref.read(cyclesOfProgramProvider);
    cycles.removeAt(cycleIndex);
    ref.read(cyclesOfProgramProvider.notifier).state = [...cycles];
    ref.read(hasProgramChangedProvider.notifier).state = true;
  }

  Program? getProgram(List<Program> schedule, int valve) {
    for (var program in schedule) {
      if (program.out == valve) {
        return program;
      }
    }
    return null;
  }

  List<DaysOfWeek> getDays(List<Program> schedule, int valve) {
    try {
      String days = schedule.firstWhere((program) => program.out == valve).days;
      return stringToDaysOfWeek(days);
    } catch (e) {
      return [];
    }
  }

  String getClosestTime(String times) {
    var timeNow = DateFormat('HH:mm').format(DateTime.now());
    var listOfTimes = times.split(',');
    if (!listOfTimes.contains(timeNow)) {
      listOfTimes.add(timeNow);
    }
    // If program contains a start time after current time, return this. Else return the first of the list.
    try {
      listOfTimes.sort((a, b) => a.compareTo(b));
      var index = listOfTimes.indexWhere((element) => element == timeNow);
      return listOfTimes[index + 1];
    } catch (e) {
      return listOfTimes[0];
    }
  }

  // Get the the next run of the program
  String getNextRun(List<DaysOfWeek> listOfDays, String times) {
    final loc = ref.read(appLocalizationsProvider);
    var today = DateFormat('E').format(DateTime.now());
    var todayDay = todayToDaysOfWeek(today);
    var closestTime = getClosestTime(times);
    var newListDays = [...listOfDays];

    if (!listOfDays.contains(todayDay)) {
      newListDays.add(todayDay!);
    }
    try {
      newListDays.sort((a, b) => a.index.compareTo(b.index));
      var index = newListDays.indexWhere((element) => element == todayDay);
      if (listOfDays.contains(todayDay) && timeIsAfterNow(closestTime)) {
        return loc.nextRunTodayAtText(closestTime);
      } else {
        return '${loc.day(newListDays[index + 1].name)} $closestTime'; //'${newListDays[index + 1].name} $closestTime';
      }
    } catch (e) {
      return loc.nextRunDayAtText(closestTime, loc.day(newListDays[0].name));
    }
  }

  // Get the time the valve will close
  String? getNextEnd(List<Map<String, String>> maps, String nextRun) {
    for (var map in maps) {
      var nowString = DateFormat('HH:mm').format(DateTime.now());
      var now = DateFormat('HH:mm').parse(nowString);
      var start = DateFormat('HH:mm').parse(map['start']!);
      var end = DateFormat('HH:mm').parse(map['end']!);
      if ((start.isBefore(now) || start.isAtSameMomentAs(now)) && now.isBefore(end)) {
        return map['end'];
      }
    }
    return null;
  }

  List<Map<String, String>> getTimesAsMap(List<Cycle> cycles) {
    List<Map<String, String>> listOfMap = [];
    for (var cycle in cycles) {
      if (cycle.min != '0') {
        var startTime = cycle.start;
        var startTimeInDateTime = DateFormat('HH:mm').parse(startTime);
        var endTimeInDateTime =
            startTimeInDateTime.add(Duration(minutes: int.parse(cycle.min)));
        var endTimeString = DateFormat('HH:mm').format(endTimeInDateTime);

        listOfMap.add({'start': startTime, 'end': endTimeString});
      }
    }
    return listOfMap;
  }

  String getStartTimesAsString(List<Map<String, String>> times) {
    var timesList = [];
    for (var map in times) {
      timesList.add(map['start']);
    }
    return timesList.join(',');
  }
}

// ----------- PROVIDERS ---------------

final programProvider = Provider<ProgramController>((ref) {
  return ProgramController(ref);
});
