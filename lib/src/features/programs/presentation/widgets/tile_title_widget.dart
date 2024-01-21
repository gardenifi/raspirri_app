import 'package:flutter/material.dart';
import 'package:new_gardenifi_app/src/constants/gaps.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';

class TileTitle extends StatelessWidget {
  const TileTitle({
    super.key,
    required this.name,
    required this.valveIsOn,
  });

  final String name;
  final bool valveIsOn;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyles.mediumBold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        gapW20,
        if (valveIsOn)
          const Icon(
            Icons.autorenew,
            color: Colors.green,
          ),
      ],
    );
  }
}
