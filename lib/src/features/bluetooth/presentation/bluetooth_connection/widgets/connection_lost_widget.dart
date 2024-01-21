import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_controller.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class ConnectionLostWidget extends ConsumerWidget {
  const ConnectionLostWidget(this.device, {super.key});

  final BluetoothDevice device;

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
                loc.couldNotConnectBluetoothText,
                style: TextStyles.mediumBold,
                textAlign: TextAlign.center,
              ),
              TextButton(
                  onPressed: () async {
                    ref.invalidate(bluetoothControllerProvider);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    loc.tryAgainButtonLabel,
                    style: TextStyles.smallNormal,
                  )),
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
