// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/common_widgets/alert_dialogs.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/program_controller.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/screens/create_program_screen.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class DeleteProgramButtonWidget extends StatelessWidget {
  const DeleteProgramButtonWidget({
    super.key,
    required this.ref,
    required this.widget,
    required this.context,
  });

  final WidgetRef ref;
  final CreateProgramScreen widget;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final loc = ref.read(appLocalizationsProvider);
    return TextButton(
      child: Text(
        loc.deleteProgramButtonLabel,
        style: TextStyles.xSmallNormal.copyWith(color: Colors.red[800]),
      ),
      onPressed: () async {
        var delete = await showAlertDialog(
            context: context,
            title: loc.programDeletionDialogTitle,
            defaultActionText: loc.yesLabel,
            cancelActionText: loc.cancelLabel,
            content: loc.programDeletionDialogContent);
        if (delete == true) {
          var res = ref.read(programProvider).deleteProgram(widget.valve);
          Navigator.pop(context, res);
        }
      },
    );
  }
}
