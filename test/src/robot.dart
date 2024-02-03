import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';
import 'package:new_gardenifi_app/src/root_app.dart';

// Creating a mock MqttController which returns AsyncData
class MockMqttControllerWithData extends MqttController {
  MockMqttControllerWithData(Ref ref) : super(ref) {
    state = const AsyncData(null);
  }
}

// Creating a mock MqttController which returns AsyncLoading
class MockMqttControllerWithLoading extends MqttController {
  MockMqttControllerWithLoading(Ref ref) : super(ref) {
    state = const AsyncLoading();
  }
}

// Creating a mock MqttController which returns AsyncError
class MockMqttControllerWithError extends MqttController {
  MockMqttControllerWithError(Ref ref) : super(ref) {
    state = AsyncError('Returned Error', StackTrace.current);
  }
}

class Robot {
  Robot({required this.tester});
  WidgetTester tester;

  Future<void> openProgramScreen(bool isLoading, bool hasError) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: !isLoading
            ? hasError
                ? [
                    mqttControllerProvider
                        .overrideWith((ref) => MockMqttControllerWithError(ref))
                  ]
                : [
                    valvesTopicProvider.overrideWith((ref) => ['1', '2', '3']),
                    mqttControllerProvider
                        .overrideWith((ref) => MockMqttControllerWithData(ref)),
                  ]
            : [
                mqttControllerProvider
                    .overrideWith((ref) => MockMqttControllerWithLoading(ref))
              ],
        child: const MaterialApp(
          home: RootApp(deviceHasBeenInitialized: true),
        ),
      ),
    );
    await tester.pump();
  }

  // Future<void> openProgramScreenForCheckingConnection() async {
  //   await tester.pumpWidget(
  //     ProviderScope(
  //       overrides: [
  //         valvesTopicProvider.overrideWith((ref) => ['1', '2', '3']),
  //         mqttControllerProvider.overrideWith((ref) => MockMqttControllerWithData(ref)),
  //         disconnectedProvider.overrideWith((ref) => true)
  //       ],
  //       child: const MaterialApp(
  //         home: RootApp(deviceHasBeenInitialized: true),
  //       ),
  //     ),
  //   );
  //   await tester.pumpAndSettle();

  // }

  void expectFindCircularProgressIndicator() {
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);
  }

  void expectFindError() {
    final finder = find.text('Returned Error');
    expect(finder, findsOneWidget);
  }

  void expectFindThreeListTiles() {
    final finder = find.byType(ListTile);
    expect(finder, findsNWidgets(3));
  }

  Future<void> openEditProgramScreen() async {
    final finder = find.text('Valve 1');
    await tester.tap(finder);
    await tester.pumpAndSettle();
    final textButton = find.byType(TextButton);
    await tester.tap(textButton);
    await tester.pumpAndSettle();
    final editProgramText = find.text('Edit/Create program');
    expect(editProgramText, findsOneWidget);
  }
}
