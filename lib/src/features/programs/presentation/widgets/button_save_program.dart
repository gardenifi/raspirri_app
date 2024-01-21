
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';

import 'package:new_gardenifi_app/src/features/programs/domain/cycle.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/program.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/program_controller.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/screens/create_program_screen.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/days_of_week_widget.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';
import 'package:new_gardenifi_app/utils.dart';

class SaveProgramButton extends StatelessWidget {
  const SaveProgramButton({
    Key? key,
    required this.widget,
    required this.ref,
    required this.daysSelected,
    required this.cyclesOfCurrentProgram,
    required this.currentSchedule,
    required this.context,
  }) : super(key: key);

  final CreateProgramScreen widget;
  final WidgetRef ref;
  final List<DaysOfWeek> daysSelected;
  final List<Cycle> cyclesOfCurrentProgram;
  final List<Program> currentSchedule;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final loc = ref.read(appLocalizationsProvider);
    return OutlinedButton(
      onPressed: () {
        var tzOffset = DateTime.now().timeZoneOffset.inHours;
        var listOfDays = convertListDaysOfWeekToListString(daysSelected).join(',');
        var program = Program(
          out: widget.valve,
          name: widget.name,
          days: listOfDays,
          cycles: cyclesOfCurrentProgram,
          tz_offset: tzOffset,
        );
        // Check if there is already a program for this valve and return 1 or -1
        var index = currentSchedule.indexWhere(
          (program) => program.out == widget.valve,
        );
        // If already exist a program for this valve, replace it with the new created, else add this to the schedule(List<Program)
        if (index != -1) {
          currentSchedule[index] = program;
        } else {
          currentSchedule.add(program);
        }
        var res = ref.read(programProvider).sendSchedule(currentSchedule);
        Navigator.pop(context, res);
      },
      style: OutlinedButton.styleFrom(fixedSize: const Size(250, 20)),
      child: Text(
        loc.saveButtonLabel,
        style: TextStyles.smallBold,
      ),
    );
  }
}
