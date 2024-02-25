import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_gardenifi_app/src/root_app.dart';

void main() {
  testWidgets('Open WelcomeScreen if [deviceHasBeenInitialized] is false', (tester) async {
    await tester.pumpWidget(const ProviderScope(
        child: MaterialApp(
      home: RootApp(deviceHasBeenInitialized: false),
    )));
    final bluetoothConnectionButton = find.text('Bluetooth Connection');
    expect(bluetoothConnectionButton, findsOneWidget);
  });


  testWidgets('Dont open WelcomeScreen if [deviceHasBeenInitialized] is true', (tester) async {
    await tester.pumpWidget(const ProviderScope(
        child: MaterialApp(
      home: RootApp(deviceHasBeenInitialized: true),
    )));
    final bluetoothConnectionButton = find.text('Bluetooth Connection');
    expect(bluetoothConnectionButton, findsNothing);
  });
}
