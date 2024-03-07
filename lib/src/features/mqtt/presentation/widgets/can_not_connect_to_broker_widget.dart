import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/constants/text_styles.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';
import 'package:new_gardenifi_app/utils.dart';

class CanNotConnectToBrokerWidget extends ConsumerWidget {
  const CanNotConnectToBrokerWidget({super.key});

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
            flex: 3,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      loc.cantConnectToBrokerText,
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
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(loc.ifProblemPersistText),
                  TextButton(
                      onPressed: () =>
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
