import 'package:flutter/material.dart';
import 'package:new_gardenifi_app/src/constants/gaps.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.textStyle =TextStyles.bigBold,
  });

  final String title;
  final String? subtitle;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: textStyle,
        ),
        Text(
          subtitle ?? '',
          style: TextStyles.xSmallNormal,
        ),
        gapH24,
        const CircularProgressIndicator()
      ],
    );
  }
}
