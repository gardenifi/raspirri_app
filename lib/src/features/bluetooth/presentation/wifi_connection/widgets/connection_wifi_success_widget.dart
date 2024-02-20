// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/common_widgets/bottom_screen_widget.dart';
import 'package:new_gardenifi_app/src/constants/gaps.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/screens/programs_screen.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionWifiSuccessWidget extends ConsumerWidget {
  const ConnectionWifiSuccessWidget({
    super.key,
    required this.context,
    required this.ref,
  });

  final BuildContext context;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = ref.read(appLocalizationsProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    loc.deviceConnectedText,
                    style: TextStyles.mediumBold,
                    textAlign: TextAlign.center,
                  ),
                  gapH32,
                  const Icon(
                    Icons.wifi,
                    size: 40,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
          BottomWidget(
            context: context,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isBluetoothOn: true,
            text: loc.goToMainScreenText,
            buttonText: loc.continueButtonLabel,
            ref: ref,
            callback: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('initialized', true);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const ProgramsScreen(),
              ));
            },
          )
        ],
      ),
    );
  }
}
