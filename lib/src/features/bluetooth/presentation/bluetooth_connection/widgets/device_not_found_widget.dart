import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_controller.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class DeviceNotFoundWidget extends StatelessWidget {
  const DeviceNotFoundWidget({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final loc = ref.read(appLocalizationsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            loc.deviceNotFoundTitle,
            style: TextStyles.mediumBold,
            textAlign: TextAlign.center,
          ),
          Text(
            loc.deviceNotFoundSubtitle,
            style: TextStyles.xSmallNormal,
          ),
          TextButton(
              onPressed: () async {
                await ref.read(bluetoothControllerProvider.notifier).startScanStream();
                await ref.read(bluetoothControllerProvider.notifier).startScan();
              },
              child: Text(
                loc.tryAgainButtonLabel,
                style: TextStyles.smallNormal,
              )),
        ],
      ),
    );
  }
}
