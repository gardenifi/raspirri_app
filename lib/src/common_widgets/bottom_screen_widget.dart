import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/common_widgets/big_green_button.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';

class BottomWidget extends StatelessWidget {
  const BottomWidget({
    super.key,
    required this.context,
    required this.screenWidth,
    required this.screenHeight,
    required this.isBluetoothOn,
    required this.text,
    required this.buttonText,
    required this.ref,
    required this.callback,
  });

  final BuildContext context;
  final double screenWidth;
  final double screenHeight;
  final bool isBluetoothOn;
  final String text;
  final String buttonText;
  final WidgetRef ref;
  final Future<void> Function() callback;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            child: Text(
              text,
              style: TextStyles.xSmallNormal,
            ),
          ),
          BigGreenButton(buttonText, isBluetoothOn, callback)
        ],
      ),
    );
  }
}
