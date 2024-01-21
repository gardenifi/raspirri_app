import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class DeviceDisconnectedWidget extends ConsumerWidget {
  const DeviceDisconnectedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = ref.read(appLocalizationsProvider);
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                loc.deviceDisconnectedFromBrokerText,
                style: TextStyles.mediumBold.copyWith(color: Colors.red[900]),
                textAlign: TextAlign.center,
              ),
              Text(
                loc.makeSureDeviceIsPoweredOnText,
                style: TextStyles.smallNormal,
              ),
            ],
          ),
        ),
        // A placeholder instead of button while device is not connected
        Flexible(
          flex: 1,
          child: Container(
            height: 100,
          ),
        ),
      ],
    ));
  }
}
