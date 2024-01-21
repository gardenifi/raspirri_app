// ignore_for_file: constant_identifier_names
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/day_button.dart';

enum DaysOfWeek {
  Mon,
  Tue,
  Wed,
  Thu,
  Fri,
  Sat,
  Sun,
}

class DaysOfWeekWidget extends ConsumerStatefulWidget {
  const DaysOfWeekWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DaysOfWeekWidgetState();
}

class _DaysOfWeekWidgetState extends ConsumerState<DaysOfWeekWidget> {
  List<String> daysOfWeek =
      DateFormat.EEEE(Platform.localeName).dateSymbols.SHORTWEEKDAYS;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Row(
            children: createDaysWidget(constraints.maxWidth),
          ),
        ),
      );
    });
  }

  createDaysWidget(double maxWidth) {
    List<Widget> list = [];
    for (var i in DaysOfWeek.values) {
      list.add(DayButton(day: i, maxWidth: maxWidth));
    }
    return list;
  }
}
