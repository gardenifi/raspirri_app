import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/constants/gaps.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class PairingSuccessWidget extends ConsumerWidget {
  const PairingSuccessWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = ref.read(appLocalizationsProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          loc.pairingSuccesfulText,
          style: TextStyles.bigBold,
        ),
        gapH32,
        const Icon(
          Icons.bluetooth_connected,
          size: 40,
          color: Colors.blue,
        ),
      ],
    );
  }
}
