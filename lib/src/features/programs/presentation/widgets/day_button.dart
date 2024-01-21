// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/screens/create_program_screen.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/days_of_week_widget.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class DayButton extends ConsumerStatefulWidget {
  const DayButton({required this.day, required this.maxWidth, super.key});

  final DaysOfWeek day;
  final double maxWidth;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DayButtonState();
}

class _DayButtonState extends ConsumerState<DayButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loc = ref.read(appLocalizationsProvider);
    // The current selected days
    final currentSelectedDays = ref.watch(daysOfProgramProvider);
    final isSelected = currentSelectedDays.contains(widget.day);

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: const EdgeInsets.all(2.0),
          child: ElevatedButton(
            child: Text(
              loc.day(widget.day.name) ,
              style: TextStyle(color: isSelected ? Colors.white : null),
            ),
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
                minimumSize: Size(constraints.maxWidth, 50),
                backgroundColor: isSelected ? Colors.green[400] : null),
            onPressed: () {
              if (ref.read(cyclesOfProgramProvider).isNotEmpty) {
                ref.read(hasProgramChangedProvider.notifier).state = true;
              }
              setState(() {
                if (!isSelected) {
                  var state = ref.read(daysOfProgramProvider);
                  var newState = [...state, widget.day];
                  newState.sort((a, b) => a.index.compareTo(b.index));
                  ref.read(daysOfProgramProvider.notifier).state = newState;
                } else {
                  var state = ref.read(daysOfProgramProvider);
                  state.remove(widget.day);
                  ref.read(daysOfProgramProvider.notifier).state = [...state];
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
