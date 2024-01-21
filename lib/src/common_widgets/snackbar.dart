import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String title, {IconData? icon, Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Expanded(child: Text(title)),
        Icon(
          icon,
          color: color,
        )
      ]),
      duration: const Duration(seconds: 3),
      width: MediaQuery.of(context).size.width * 0.8,
      behavior: SnackBarBehavior.floating,
    ));
  }