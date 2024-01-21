import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

Future<bool?> showDisconnectedAlertDialog({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final loc = ref.read(appLocalizationsProvider);
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog.adaptive(
        title: Text(
          loc.disconnectedFromBrokerText,
          style: TextStyles.mediumBold,
        ),
        content: Text(
          loc.makeSureYouAreConnectedText,
          style: TextStyles.smallNormal,
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(loc.okLabel)),
        ]),
  );
}
