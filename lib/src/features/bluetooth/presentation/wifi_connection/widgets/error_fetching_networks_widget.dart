import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/common_widgets/button_placeholder.dart';
import 'package:new_gardenifi_app/src/common_widgets/error_message_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/wifi_connection/widgets/refresh_networks_button.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class ErrorFetchingNetworksWidget extends ConsumerWidget {
  const ErrorFetchingNetworksWidget({
    super.key,
    required this.callback,
  });

  final Function() callback;

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
                ErrorMessageWidget(loc.somethingWentWrongText),
                RefreshNetworksButton(callback: callback),
              ],
            ),
          ),
          const Flexible(
            flex: 1,
            child: ButtonPlaceholder(),
          )
        ],
      ),
    );
  }
}
