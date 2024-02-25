import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_gardenifi_app/src/common_widgets/no_bluetooth_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_connection/widgets/connection_lost_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/wifi_connection/widgets/refresh_networks_button.dart';

import '../../../../../commons.dart';
import '../../../../../mocks.dart';
import '../../../wifi_robot.dart';

void main() {
  testWidgets(
    '''Given WiFiSetupScreen is opened
       When bluetooth goes OFF
       Then NoBluetoothWidget pumps''',
    (tester) async {
      final r = WifiRobot(tester);

      await r.pumpWifiSetupScreen(
          device: fakeBluetoothDevice,
          bluetoothIsOn: false,
          deviceConnectionState: BluetoothConnectionState.connected);

      expect(find.byType(NoBluetoothWidget), findsOneWidget);
    },
  );

  testWidgets(
    '''Given  WiFiSetupScreen is opened
       And Bluetooth is ON
       When BluetoothDevice disconnect
       Then ConnectionLostWidget pumps''',
    (tester) async {
      final r = WifiRobot(tester);

      await r.pumpWifiSetupScreen(
          device: fakeBluetoothDevice,
          bluetoothIsOn: true,
          deviceConnectionState: BluetoothConnectionState.disconnected);

      expect(find.byType(ConnectionLostWidget), findsOneWidget);
    },
  );

  testWidgets(
    '''Given  WiFiSetupScreen is opened
       And Bluetooth is ON
       And BluetoothDevice is connected
       And networks fetched
       Then show the main screen''',
    (tester) async {
      final r = WifiRobot(tester);

      await r.pumpWifiSetupScreen(
          device: fakeBluetoothDevice,
          bluetoothIsOn: true,
          deviceConnectionState: BluetoothConnectionState.connected);

      expect(find.byType(RefreshNetworksButton), findsOneWidget);
    },
  );

  testWidgets('''
       When Refresh List button is pressed
       Then fetching again networks
       And DropdownButton should have no value
      ''', (tester) async {
    final r = WifiRobot(tester);
    final dropdownFinder = find.byType(DropdownButton<String>);

    await r.pumpWifiSetupScreen(
        device: fakeBluetoothDevice,
        bluetoothIsOn: true,
        deviceConnectionState: BluetoothConnectionState.connected);

    await r.tapDropdownButton(dropdownFinder);
    // Select a network from DropdownButton
    expect(find.text('MyNetwork1'), findsOneWidget);
    await r.tapRefreshListButton();
    // DropdownButton should has no value selected
    expect(find.text('MyNetwork1'), findsNothing);
  });

  testWidgets(
    'Select network, enter password and tap Connect button flow',
    (tester) async {
      final r = WifiRobot(tester);
      final dropdownFinder = find.byType(DropdownButton<String>);
      final textFieldFinder = find.byType(TextField);

      registerFallbackValue(FakeRoute());

      await r.pumpWifiSetupScreen(
        device: fakeBluetoothDevice,
        bluetoothIsOn: true,
        deviceConnectionState: BluetoothConnectionState.connected,
        hasObserver: true,
      );

      final container = r.getProviderContainer();

      r.expectProvidersHaveInitialValue(container);
      r.expectFindDropdownButton(dropdownFinder);
      r.expectFindPasswordTextField(textFieldFinder);
      r.expectDropdownButtonHasNoValue();
      r.expectPasswordTextFieldIsDisabled(textFieldFinder);
      r.expectConnectButtonIsNotEnabled();
      await r.tapDropdownButton(dropdownFinder);
      r.expectDropdownButtonHasValue();
      await r.tapAndSelectNetwork(dropdownFinder);
      r.expectPasswordTextFieldIsEnabled(textFieldFinder);
      await r.enterPassowrdToTextField('1234');
      r.expectProvidersUpdatedTheirState(container);
      r.expectConnectButtonIsEnabled();
      await r.tapContinueButton();
      r.expectNavigatorPushedNewScreen();
    },
  );
}
