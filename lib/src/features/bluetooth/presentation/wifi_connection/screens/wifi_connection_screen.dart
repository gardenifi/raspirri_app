import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/common_widgets/screen_upper_portrait.dart';
import 'package:new_gardenifi_app/src/common_widgets/error_message_widget.dart';
import 'package:new_gardenifi_app/src/constants/colors.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_controller.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/wifi_connection/widgets/connection_wifi_success_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/wifi_connection/widgets/could_not_connect_to_internet_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/wifi_connection/widgets/wait_while_connecting_widget.dart';

class WifiConnectionScreen extends ConsumerStatefulWidget {
  const WifiConnectionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WifiConnectionScreenState();
}

class _WifiConnectionScreenState extends ConsumerState<WifiConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final radius = screenHeight / 4;

    // AsyncValue that watch if device connected to internet or not
    final connectionState = ref.watch(wifiConnectionStatusProvider);

    return Scaffold(
      backgroundColor: screenBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                ScreenUpperPortrait(
                    radius: radius, showMenuButton: false, showLogo: true),
                connectionState.when(
                  data: (data) {
                    return connectionState.isLoading
                        ? const WaitWhileConnectingWidget()
                        : data == '1'
                            ? ConnectionWifiSuccessWidget(context: context, ref: ref)
                            : const CouldNotConnectToInternetWidget();
                  },
                  error: (error, stackTrace) => ErrorMessageWidget(error.toString()),
                  loading: () => const WaitWhileConnectingWidget(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
