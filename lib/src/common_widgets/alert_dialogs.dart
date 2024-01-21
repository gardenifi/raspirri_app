import 'package:flutter/material.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';

Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  String? cancelActionText,
  required defaultActionText,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: cancelActionText != null,
    builder: (context) => Container(
      constraints: const BoxConstraints(
        maxWidth: 200,
      ),
      child: AlertDialog(
          title: Text(
            title,
            style: TextStyles.bigBold,
          ),
          content: content != null
              ? Text(
                  content,
                  style: TextStyles.smallNormal,
                )
              : null,
          actions: <Widget>[
            if (cancelActionText != null)
              TextButton(
                child: Text(cancelActionText, style: TextStyles.mediumNormal),
                onPressed: () => Navigator.pop(context, false),
              ),
            TextButton(
              child: Text(defaultActionText, style: TextStyles.mediumNormal),
              onPressed: () => Navigator.pop(context, true),
            ),
          ]),
    ),
  );
}

// Generic function to show a platform-aware Material or Cupertino error dialog
Future<void> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) =>
    showAlertDialog(
      context: context,
      title: title,
      content: exception.toString(),
      defaultActionText: 'Ok',
    );
