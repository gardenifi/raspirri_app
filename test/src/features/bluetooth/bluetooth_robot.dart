import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_gardenifi_app/src/common_widgets/no_bluetooth_widget.dart';
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

  Future<void> pumpBluetoothConnectionScreen(
      {required bool bluetoothIsOn,
      required MockBluetoothController bluetoothController,
      required BluetoothConnectionState? deviceConnectionState,
      bool pumpAndSettle = true,
      List<NavigatorObserver> observer = const []}) async {
    await tester.pumpWidget(ProviderScope(
        overrides: [
          bluetoothControllerProvider.overrideWith((ref) => bluetoothController),
          connectionProvider.overrideWith((ref) => Stream.value(deviceConnectionState!)),
          bluetoothIsOn
              ? bluetoothAdapterStateStreamProvider
                  .overrideWith((ref) => Stream.value(BluetoothAdapterState.on))
              : bluetoothAdapterStateStreamProvider
                  .overrideWith((ref) => Stream.value(BluetoothAdapterState.off))
        ],
        child: MaterialApp(
          navigatorObservers: observer,
          home: const BluetoothConnectionScreen(),
        )));

    if (pumpAndSettle) {
      await tester.pumpAndSettle();
    }
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

  Future<void> pumpNoBluetoothWidget(MockBluetoothRepository repository) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        bluetoothRepositoryProvider.overrideWithValue(repository),
      ],
      child: const MaterialApp(
        home: NoBluetoothWidget(),
      ),
    ));
  }

  void expectFindTurnOnBluetoothButton(Finder finder) {
    expect(finder, findsOneWidget);
  }

  Future<void> tapTurnOnBluetoothButton(
      Finder finder, MockBluetoothRepository repository) async {
    when(() => repository.turnBluetoothOn()).thenAnswer((_) => Future.value());
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  void expectCallingTurnOnBluetoothMethod(MockBluetoothRepository repository) {
    verify(() => repository.turnBluetoothOn()).called(1);
  }
}
