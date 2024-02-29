import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_gardenifi_app/src/common_widgets/bottom_screen_widget.dart';
import 'package:new_gardenifi_app/src/common_widgets/error_message_widget.dart';
import 'package:new_gardenifi_app/src/common_widgets/progress_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_connection/widgets/could_not_connect_bluetooth_widget.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_connection/widgets/pairing_success_widget.dart';

import '../../../../../commons.dart';
import '../../../../../mocks.dart';
import '../../../bluetooth_robot.dart';

void main() {
    testWidgets(
    '''Given bluetooth is On
       When BluetoothConnectionScreen opens
       And device NOT found
       Then show appropriate widget
    ''',
    (tester) async {
      // setup
      final r = BluetoothRobot(tester);
      final mockBluetoothController =
          MockBluetoothController(const AsyncData<BluetoothDevice?>(null));

      when(() => mockBluetoothController.startScanStream())
          .thenAnswer((_) => Future.value());
      when(() => mockBluetoothController.startScan()).thenAnswer((_) => Future.value());
      when(() => mockBluetoothController.stopScan()).thenAnswer((_) => Future.value());
      // run
      await r.pumpBluetoothConnectionScreen(
          bluetoothIsOn: true,
          bluetoothController: mockBluetoothController,
          deviceConnectionState: BluetoothConnectionState.disconnected);
      // verify
      final finder =
          find.text('IoT Device not found \nor connection with ΙοΤ device lost');
      expect(finder, findsOneWidget);
    },
  );

  testWidgets(
    '''Given bluetooth is Off
       When BluetoothConnectionScreen opens
       And device NOT found
       Then show appropriate widget
    ''',
    (tester) async {
      // setup
      final r = BluetoothRobot(tester);
      final mockBluetoothController =
          MockBluetoothController(const AsyncData<BluetoothDevice?>(null));

      when(() => mockBluetoothController.startScanStream())
          .thenAnswer((_) => Future.value());
      when(() => mockBluetoothController.startScan()).thenAnswer((_) => Future.value());
      when(() => mockBluetoothController.stopScan()).thenAnswer((_) => Future.value());
      // run
      await r.pumpBluetoothConnectionScreen(
          bluetoothIsOn: false,
          bluetoothController: mockBluetoothController,
          deviceConnectionState: BluetoothConnectionState.disconnected);
      // verify
      final finder = find.text('Turn on Bluetooth');
      expect(finder, findsOneWidget);
    },
  );

  testWidgets(
    '''Given bluetooth is On
       When BluetoothConnectionScreen opens
       And trying to find device
       Then show CircularProgressIndicator
    ''',
    (tester) async {
      // setup
      final r = BluetoothRobot(tester);

      final mockBluetoothController =
          MockBluetoothController(const AsyncLoading<BluetoothDevice?>());

      when(() => mockBluetoothController.startScanStream())
          .thenAnswer((_) => Future.value());
      when(() => mockBluetoothController.startScan()).thenAnswer((_) => Future.value());
      when(() => mockBluetoothController.stopScan()).thenAnswer((_) => Future.value());
      // run

      await r.pumpBluetoothConnectionScreen(
          bluetoothIsOn: true,
          bluetoothController: mockBluetoothController,
          deviceConnectionState: null,
          pumpAndSettle: false);
      await tester.pump();

      // verify
      final finder = find.byType(ProgressWidget);
      expect(finder, findsOneWidget);
      // final finder2 = find.byType(BottomWidget);
      // expect(finder2, findsNothing);
    },
  );

  testWidgets(
    '''Given bluetooth is On
       When BluetoothConnectionScreen opens
       And trying to find device return error
       Then show appropriate widget
    ''',
    (tester) async {
      // setup
      final r = BluetoothRobot(tester);

      final exception = Exception('Error');

      final mockBluetoothController = MockBluetoothController(
          AsyncError<BluetoothDevice?>(exception, StackTrace.current));

      when(() => mockBluetoothController.startScanStream())
          .thenAnswer((_) => Future.value());
      when(() => mockBluetoothController.startScan()).thenAnswer((_) => Future.value());
      when(() => mockBluetoothController.stopScan()).thenAnswer((_) => Future.value());
      // run

      await r.pumpBluetoothConnectionScreen(
          bluetoothIsOn: true,
          bluetoothController: mockBluetoothController,
          deviceConnectionState: null,
          pumpAndSettle: false);
      await tester.pump();

      // verify
      final finder = find.byType(ErrorMessageWidget);
      expect(finder, findsOneWidget);
    },
  );

  testWidgets(
    '''Given bluetooth is On
       When BluetoothConnectionScreen opens
       And device HAS found
       And connection with device throw error
       Then show appropriate widgets
    ''',
    (tester) async {
      // setup
      final r = BluetoothRobot(tester);

      final mockBluetoothController =
          MockBluetoothController(AsyncData<BluetoothDevice?>(fakeBluetoothDevice));

      when(() => mockBluetoothController.startScanStream())
          .thenAnswer((_) => Future.value());
      when(() => mockBluetoothController.startScan()).thenAnswer((_) => Future.value());
      when(() => mockBluetoothController.stopScan()).thenAnswer((_) => Future.value());
      // run
      await r.pumpBluetoothConnectionScreen(
          bluetoothIsOn: true,
          bluetoothController: mockBluetoothController,
          deviceConnectionState: null);
      // verify
      final finder = find.byType(ErrorMessageWidget);
      expect(finder, findsOneWidget);
      final finder2 = find.byType(BottomWidget);
      expect(finder2, findsNothing);
    },
  );

  testWidgets(
    '''Given bluetooth is On
       When BluetoothConnectionScreen opens
       And device HAS found
       And connection with device failed
       Then show appropriate widgets
    ''',
    (tester) async {
      // setup
      final r = BluetoothRobot(tester);

      final mockBluetoothController =
          MockBluetoothController(AsyncData<BluetoothDevice?>(fakeBluetoothDevice));

      when(() => mockBluetoothController.startScanStream())
          .thenAnswer((_) => Future.value());
      when(() => mockBluetoothController.startScan()).thenAnswer((_) => Future.value());
      when(() => mockBluetoothController.stopScan()).thenAnswer((_) => Future.value());
      // run
      await r.pumpBluetoothConnectionScreen(
          bluetoothIsOn: true,
          bluetoothController: mockBluetoothController,
          deviceConnectionState: BluetoothConnectionState.disconnected);
      // verify
      final finder1 = find.byType(CouldNotConnectBluetoothWidget);
      expect(finder1, findsOneWidget);
      final finder2 = find.byType(BottomWidget);
      expect(finder2, findsNothing);
    },
  );

  testWidgets(
    '''Given bluetooth is On
       When BluetoothConnectionScreen opens
       And device HAS found
       And device connected
       Then show appropriate widgets
    ''',
    (tester) async {
      // setup
      final r = BluetoothRobot(tester);

      final mockBluetoothController =
          MockBluetoothController(AsyncData<BluetoothDevice?>(fakeBluetoothDevice));

      when(() => mockBluetoothController.startScanStream())
          .thenAnswer((_) => Future.value());
      when(() => mockBluetoothController.startScan()).thenAnswer((_) => Future.value());
      when(() => mockBluetoothController.stopScan()).thenAnswer((_) => Future.value());
      // run
      await r.pumpBluetoothConnectionScreen(
          bluetoothIsOn: true,
          bluetoothController: mockBluetoothController,
          deviceConnectionState: BluetoothConnectionState.connected);
      // verify
      final finder1 = find.byType(PairingSuccessWidget);
      expect(finder1, findsOneWidget);
      final finder2 = find.byType(BottomWidget);
      expect(finder2, findsOneWidget);
    },
  );

  testWidgets(
    '''Given BluetoothConnectionScreen opens
       When tap Continue button
       Then Navigator called
    ''',
    (tester) async {
      // setup
      registerFallbackValue(FakeRoute());
      final r = BluetoothRobot(tester);

      final mockBluetoothController =
          MockBluetoothController(AsyncData<BluetoothDevice?>(fakeBluetoothDevice));

      final mockObserver = MockNavigatorObserver();

      when(() => mockBluetoothController.startScanStream())
          .thenAnswer((_) => Future.value());
      when(() => mockBluetoothController.startScan()).thenAnswer((_) => Future.value());
      when(() => mockBluetoothController.stopScan()).thenAnswer((_) => Future.value());
      // run
      await r.pumpBluetoothConnectionScreen(
          bluetoothIsOn: true,
          bluetoothController: mockBluetoothController,
          deviceConnectionState: BluetoothConnectionState.connected,
          observer: [mockObserver]);

      // verify
      final finder = find.widgetWithText(ElevatedButton, 'Continue');
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pump();
      verify(() => mockObserver.didPush(any(), any())).called(greaterThan(0));
    },
  );
}
