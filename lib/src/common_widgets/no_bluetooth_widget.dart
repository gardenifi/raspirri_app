import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/constants/gaps.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/data/bluetooth_repository.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class NoBluetoothWidget extends StatelessWidget {
  const NoBluetoothWidget({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final loc = ref.read(appLocalizationsProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Text(
        loc.noBluetoothPrompt,
        style: TextStyles.alertMessage,
      ),
      TextButton(
        child: Text(
          loc.noBluetoothAction,
          style: TextStyles.smallBold.copyWith(color: Colors.blue),
        ),
        onPressed: () async {
          await ref.read(bluetoothRepositoryProvider).turnBluetoothOn();
        },
      ), gapH64
    ]);
  }
}
