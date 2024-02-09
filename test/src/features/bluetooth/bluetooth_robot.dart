import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/data/bluetooth_repository.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_connection/screens/bluetooth_connection_screen.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_controller.dart';
import 'package:new_gardenifi_app/src/root_app.dart';

import '../../mocks.dart';

class BluetoothRobot {
  BluetoothRobot(this.tester);
  WidgetTester tester;

  Future<void> pumpWelcomeScreen(
      {required bool isBluetoothOn, required bool deviceHasBeenInitialized}) async {
    await tester.pumpWidget(ProviderScope(
        overrides: [
          isBluetoothOn
              ? bluetoothAdapterStateStreamProvider
                  .overrideWith((ref) => Stream.value(BluetoothAdapterState.on))
              : bluetoothAdapterStateStreamProvider
                  .overrideWith((ref) => Stream.value(BluetoothAdapterState.off))
        ],
        child: const MaterialApp(
          home: RootApp(deviceHasBeenInitialized: false),
        )));

    await tester.pumpAndSettle();
  }

  Future<void> pumpBluetoothConnectionScreen({required bool bluetoothIsOn}) async {
    final mockBluetoothController =
        MockBluetoothController(const AsyncData<BluetoothDevice?>(null));

    when(() => mockBluetoothController.startScanStream())
        .thenAnswer((_) => Future.value());

    when(() => mockBluetoothController.startScan()).thenAnswer((_) => Future.value());

    when(() => mockBluetoothController.stopScan()).thenAnswer((_) => Future.value());
    await tester.pumpWidget(ProviderScope(
        overrides: [
          bluetoothControllerProvider.overrideWith((ref) => mockBluetoothController),
          bluetoothIsOn
              ? bluetoothAdapterStateStreamProvider
                  .overrideWith((ref) => Stream.value(BluetoothAdapterState.on))
              : bluetoothAdapterStateStreamProvider
                  .overrideWith((ref) => Stream.value(BluetoothAdapterState.off))
        ],
        child: const MaterialApp(
          home: BluetoothConnectionScreen(),
        )));

    await tester.pumpAndSettle();
  }

  void expectFoundTextButton(bool found) {
    final finder = find.byType(TextButton);
    expect(finder, found ? findsOneWidget : findsNothing);
  }

  void expectButtonIsEnabled(bool enabled) {
    final bluetoothConnectionButton = find.byType(ElevatedButton);
    expect(bluetoothConnectionButton, findsOneWidget);
    final button = tester.widget<ElevatedButton>(bluetoothConnectionButton);
    expect(button.onPressed, enabled ? isNotNull : null);
  }

  Future<void> tapConnectionButton() async {
    final bluetoothConnectionButton = find.text('Bluetooth Connection');
    expect(bluetoothConnectionButton, findsOneWidget);
    await tester.tap(bluetoothConnectionButton);
    await tester.pumpAndSettle();
  }

  void expectingNoBluetoothConnectionButton() {
    final bluetoothConnectionButton = find.text('Bluetooth Connection');
    expect(bluetoothConnectionButton, findsNothing);
  }

  void expectFindCircularProgressIndicator() {
    final finder = find.text('Searching IoT device...');
    expect(finder, findsOneWidget);
  }
}
