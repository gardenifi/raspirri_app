import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/cycle.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/days_of_week_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool?> checkInitializationStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    bool? initialized = prefs.getBool('initialized');
    if (initialized != null && initialized == true) {
      return true;
    }
  } catch (error) {
    log('Main:: Error on geting bool initialized ');
  }
  return false;
}

TimeOfDay convertStringToTimeOfDay(BuildContext context, String startTime) {
  DateTime dateTime = DateFormat.Hm().parse(startTime);
  TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);
  return timeOfDay;
}

void refreshMainScreen(WidgetRef ref) {
  ref.invalidate(cantConnectProvider);
  ref.invalidate(disconnectedProvider);
  ref.invalidate(mqttControllerProvider);
  ref.invalidate(configTopicProvider);
  ref.invalidate(statusTopicProvider);
  ref.invalidate(valvesTopicProvider);
  ref.read(mqttControllerProvider.notifier).setupAndConnectClient();
}

List<Cycle> addCycleAndSortList(List<Cycle> cycles, Cycle cycle) {
  var newCycles = [...cycles, cycle];
  newCycles.sort(((a, b) => a.start.compareTo(b.start)));
  return newCycles;
}

extension StringCasingExtension on String {
  String toDecapitalized() => length > 0 ? '${this[0].toLowerCase()}${substring(1)}' : '';
}

List<DaysOfWeek> stringToDaysOfWeek(String days) {
  List<DaysOfWeek> listOfDaysOfWeek = [];
  List<String> listOfStringDays = days.split(',');
  for (var day in listOfStringDays) {
    switch (day) {
      case 'mon':
        listOfDaysOfWeek.add(DaysOfWeek.Mon);
      case 'tue':
        listOfDaysOfWeek.add(DaysOfWeek.Tue);
      case 'wed':
        listOfDaysOfWeek.add(DaysOfWeek.Wed);
      case 'thu':
        listOfDaysOfWeek.add(DaysOfWeek.Thu);
      case 'fri':
        listOfDaysOfWeek.add(DaysOfWeek.Fri);
      case 'sat':
        listOfDaysOfWeek.add(DaysOfWeek.Sat);
      case 'sun':
        listOfDaysOfWeek.add(DaysOfWeek.Sun);
    }
  }
  return listOfDaysOfWeek;
}

DaysOfWeek? todayToDaysOfWeek(String day) {
  switch (day) {
    case 'Mon':
      return DaysOfWeek.Mon;
    case 'Tue':
      return DaysOfWeek.Tue;
    case 'Wed':
      return DaysOfWeek.Wed;
    case 'Thu':
      return DaysOfWeek.Thu;
    case 'Fri':
      return DaysOfWeek.Fri;
    case 'Sat':
      return DaysOfWeek.Sat;
    case 'Sun':
      return DaysOfWeek.Sun;
  }
  return null;
}

List<String> convertListDaysOfWeekToListString(List<DaysOfWeek> listDaysOfWeek) {
  var listOfDaysString = listDaysOfWeek.map((e) {
    var nameOfDay = e.name;
    return nameOfDay.toDecapitalized();
  }).toList();
  return listOfDaysString;
}

// Compare a given time with current time
bool timeIsAfterNow(String time) {
  var timeNow = DateFormat('HH:mm').format(DateTime.now());
  var res = time.compareTo(timeNow);
  if (res == 1) {
    return true;
  } else {
    return false;
  }
}
