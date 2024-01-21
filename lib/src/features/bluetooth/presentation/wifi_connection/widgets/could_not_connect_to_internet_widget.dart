import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/constants/gaps.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_controller.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class CouldNotConnectToInternetWidget extends ConsumerWidget {
  const CouldNotConnectToInternetWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = ref.read(appLocalizationsProvider);
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  loc.deviceCouldNotConnectText,
                  style: TextStyles.mediumBold,
                  textAlign: TextAlign.center,
                ),
                TextButton(
                    onPressed: () async {
                      ref.invalidate(wifiConnectionStatusProvider);
                    },
                    child: Text(
                      loc.tryAgainButtonLabel,
                      style: TextStyles.smallNormal,
                    )),
                gapH32,
                const Icon(
                  Icons.wifi_off,
                  size: 40,
                  color: Colors.red,
                )
              ],
            ),
          ), // A placeholder instead of button while device is not connected
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 100,
              child: Column(
                children: [
                  Text(loc.ifProblemPersistText),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(loc.goBackButtonLabel))
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
