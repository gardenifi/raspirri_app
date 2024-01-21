import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';
import 'package:new_gardenifi_app/utils.dart';

class DisconnectedFromBrokerWidget extends ConsumerWidget {
  const DisconnectedFromBrokerWidget({super.key});

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
                  loc.disconnectedFromBrokerText,
                  style: TextStyles.mediumBold.copyWith(color: Colors.red[900]),
                  textAlign: TextAlign.center,
                ),
                Text(
                  loc.makeSureYouAreConnectedText,
                  style: TextStyles.smallNormal,
                  textAlign: TextAlign.center,
                ),
                TextButton(
                    onPressed: () async {
                      // Reset providers and try to connect to broker
                      refreshMainScreen(ref);
                    },
                    child: Text(
                      loc.tryAgainButtonLabel,
                      style: TextStyles.smallNormal,
                    )),
              ],
            ),
          ), // A placeholder instead of button while device is not connected
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 100,
              child: Column(
                children: [
                  Text(loc.ifProblemPersistOnDisconnectingFromBrokerText),
                  TextButton(
                      onPressed: () =>
                          // Exit the app
                          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                      child: Text(loc.exitButtonLabel))
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
