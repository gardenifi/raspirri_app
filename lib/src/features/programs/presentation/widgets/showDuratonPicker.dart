import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

Future<Duration?> showDurationPickerDialog(BuildContext context, WidgetRef ref) async {
  final loc = ref.read(appLocalizationsProvider);
  Duration duration = const Duration(minutes: 1);
  var res = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
            title: Text(
              loc.selectDurationTitle,
              style: TextStyles.smallNormal,
            ),
            content: DurationPicker(
              baseUnit: BaseUnit.minute,
              onChange: (val) {
                setState(() => duration = val);
              },
              duration: duration,
              snapToMins: 5.0,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(loc.cancelLabel, style: TextStyles.mediumNormal),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text(loc.okLabel, style: TextStyles.mediumNormal),
                onPressed: () => Navigator.pop(context, true),
              ),
            ]);
      });
    },
  );
  return (res) ? duration : null;
}
