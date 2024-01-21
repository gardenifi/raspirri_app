import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/add_remove_valve_widget.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class ShowAddRemoveBottomSheet {
  static Future<void> showBottomSheet(BuildContext context, WidgetRef ref) {
    final loc = ref.read(appLocalizationsProvider);
    return showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                loc.addRemoveValveBottomSheetTitle,
                style: TextStyles.mediumBold,
              ),
              const Divider(
                indent: 50,
                endIndent: 50,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AddRemoveValveWidget('1'),
                  AddRemoveValveWidget('2'),
                  AddRemoveValveWidget('3'),
                  AddRemoveValveWidget('4'),
                ],
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(loc.doneButtonLabel))
            ],
          ),
        );
      },
    );
  }
}
