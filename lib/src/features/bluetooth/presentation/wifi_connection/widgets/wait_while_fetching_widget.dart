import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/common_widgets/button_placeholder.dart';
import 'package:new_gardenifi_app/src/common_widgets/progress_widget.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class WaitWhileFetchingWidget extends ConsumerWidget {
  const WaitWhileFetchingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = ref.read(appLocalizationsProvider);
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: ProgressWidget(
              title: loc.waitWhileFetchingNetworksText,
              textStyle: TextStyles.smallBold,
            ),
          ),
          const ButtonPlaceholder(),
        ],
      ),
    );
  }
}
