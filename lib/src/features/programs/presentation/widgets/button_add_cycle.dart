// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/cycle.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/screens/create_program_screen.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/days_of_week_widget.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/showDuratonPicker.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';
import 'package:new_gardenifi_app/utils.dart';

class AddCycleButton extends ConsumerWidget {
  const AddCycleButton({
    super.key,
    required this.ref,
    required this.daysOfCurrentProgram,
    required this.context,
    required this.cyclesOfCurrentProgram,
  });

  final WidgetRef ref;
  final List<DaysOfWeek> daysOfCurrentProgram;
  final BuildContext context;
  final List<Cycle> cyclesOfCurrentProgram;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = ref.read(appLocalizationsProvider);
    late Cycle cycle;

    return TextButton.icon(
      onPressed: (daysOfCurrentProgram.isEmpty)
          ? null
          : () async {
              TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                barrierLabel: loc.selectStartTimeText,
                barrierColor: Colors.white,
                barrierDismissible: false,
              );
              if (time != null) {
                // Create a new cycle with selected start time
                cycle = Cycle(start: time.format(context));
                // Update the provider who keeps the state of cycle
                ref.read(cyclesOfProgramProvider.notifier).state = [
                  ...cyclesOfCurrentProgram,
                  cycle
                ];
                // Select the duration for that cycle
                var duration = await showDurationPickerDialog(context, ref);
                if (duration != null) {
                  ref.read(hasProgramChangedProvider.notifier).state = true;
                  // Add the selected duration to the previous new created cycle
                  cycle.min = duration.inMinutes.toString();
                  // Update the provider
                  ref.read(cyclesOfProgramProvider.notifier).state =
                      addCycleAndSortList(cyclesOfCurrentProgram, cycle);
                }
              }
            },
      label: Text(loc.addIrrigationCycleLabel),
      icon: const Icon(Icons.add_circle_outline),
    );
  }
}
