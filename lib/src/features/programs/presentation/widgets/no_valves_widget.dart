import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/constants/gaps.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/show_add_remov_bottomsheet.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class NoValvesWidget extends ConsumerWidget {
  const NoValvesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = ref.read(appLocalizationsProvider);
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  loc.noValveText,
                  style: TextStyles.mediumBold,
                  textAlign: TextAlign.center,
                ),
                Text(
                  loc.plugValveText,
                  style: TextStyles.smallNormal,
                  textAlign: TextAlign.center,
                ),
                gapH24,
                ElevatedButton(
                  child: Text(loc.addValvesButtonLabel),
                  onPressed: () {
                    ShowAddRemoveBottomSheet.showBottomSheet(context, ref);
                  },
                ),
              ],
            ),
          ),
          // A placeholder instead of button while device is not connected
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Container(),
            ),
          ),
        ],
      ),
    ));
  }
}
