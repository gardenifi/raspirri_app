import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_connection/screens/bluetooth_connection_screen.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_connection/screens/welcome_screen.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/wifi_connection/screens/wifi_connection_screen.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/wifi_connection/screens/wifi_setup_screen.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/screens/programs_screen.dart';

/// The Widget that configures your application.
class RootApp extends StatelessWidget {
  const RootApp({super.key, required this.deviceHasBeenInitialized});

  final bool? deviceHasBeenInitialized;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RaspirriV1',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
        restorationScopeId: 'app',
        // Provide the generated AppLocalizations to the MaterialApp. This
        // allows descendant Widgets to display the correct translations
        // depending on the user's locale.
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // If the device has not been initialized go to first screen. Else go to main program screen
        home: (deviceHasBeenInitialized == true || deviceHasBeenInitialized == null)
            ? const ProgramsScreen()
            : const WelcomeScreen(),
        // initialRoute: '/',
        routes: {
          'welcomeScreen': (context) => const WelcomeScreen(),
          'bleConnection': (context) => const BluetoothConnectionScreen(),
          'wifiConnection': (context) => const WifiConnectionScreen(),
          'wifiSetup': (context) => WiFiSetupScreen(
              ModalRoute.of(context)!.settings.arguments as BluetoothDevice),
          'programsScreen': (context) => const ProgramsScreen(),
        },
      ),
    );
  }
}
