import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/src/features/programs/program_robot.dart';

void main() {
   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Portait', () {
    testWidgets(
      '''When while fatching data from broker
       Then show CircularProgressIndicator''',
      (tester) async {
        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(
          controllerValue: const AsyncLoading(),
          doPumpAndSettle: false,
        );
        r.expectFindCircularProgressIndicator();
      },
    );

    testWidgets(
      '''When trying fatching data from broker returns error
       Then show Center widget with the error''',
      (tester) async {
        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(
            controllerValue: AsyncError('An error', StackTrace.current));
        r.expectFindErrorCenterWidget();
      },
    );
    testWidgets(
      '''When can not connect to broker
       Then show CanNotConnectToBrokerWidget''',
      (tester) async {
        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(cantConnect: true);
        r.expectFindCanNotConnectToBrokerWidget();
      },
    );

    testWidgets(
      '''When IoT device is disconnected
       Then show DeviceDisconnectedWidget''',
      (tester) async {
        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(statusValue: {'err': 'LOST_CONNECTION'});
        r.expectFindDeviceDisconnectedWidget();
      },
    );

    testWidgets(
      '''When there is no valve registered
       Then show NoValvesWidget''',
      (tester) async {
        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(valvesList: []);
        r.expectFindNoValvesWidget();
      },
    );

    testWidgets(
      '''When disconnect from broker
       Then show DisconnectedFromBrokerWidget''',
      (tester) async {
        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(disconnected: true);
        r.expectFindDisconnectedFromBroker();
      },
    );

    testWidgets(
      '''Show ValvesWidget''',
      (tester) async {
        final r = ProgramRobot(tester);
        await r.pumpProgramScreen();
        r.expectFindValvesWidget();
      },
    );
  });

  group('Landscape', () {
    testWidgets(
      '''When while fatching data from broker
       Then show CircularProgressIndicator''',
      (tester) async {
        final dpi = tester.view.devicePixelRatio;
        tester.view.physicalSize = Size(600 * dpi, 400 * dpi);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(
          controllerValue: const AsyncLoading(),
          doPumpAndSettle: false,
        );
        r.expectFindCircularProgressIndicator();
      },
    );

    testWidgets(
      '''When trying fatching data from broker returns error
       Then show Center widget with the error''',
      (tester) async {
        final dpi = tester.view.devicePixelRatio;
        tester.view.physicalSize = Size(600 * dpi, 400 * dpi);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(
            controllerValue: AsyncError('An error', StackTrace.current));
        r.expectFindErrorCenterWidget();
      },
    );
    testWidgets(
      '''When can not connect to broker
       Then show CanNotConnectToBrokerWidget''',
      (tester) async {
        /// this worked
        final dpi = tester.view.devicePixelRatio;
        tester.view.physicalSize = Size(600 * dpi, 400 * dpi);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(cantConnect: true);
        r.expectFindCanNotConnectToBrokerWidget();
      },
    );

    testWidgets(
      '''When IoT device is disconnected
       Then show DeviceDisconnectedWidget''',
      (tester) async {
        final dpi = tester.view.devicePixelRatio;
        tester.view.physicalSize = Size(600 * dpi, 400 * dpi);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(statusValue: {'err': 'LOST_CONNECTION'});
        r.expectFindDeviceDisconnectedWidget();
      },
    );

    testWidgets(
      '''When there is no valve registered
       Then show NoValvesWidget''',
      (tester) async {
        final dpi = tester.view.devicePixelRatio = 3.0;
        tester.view.physicalSize = Size(600 * dpi, 400 * dpi);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(valvesList: []);
        r.expectFindNoValvesWidget();
      },
    );

    testWidgets(
      '''When disconnect from broker
       Then show DisconnectedFromBrokerWidget''',
      (tester) async {
        WidgetsBinding.instance.renderView.configuration =
            new TestViewConfiguration(size: const Size(600.0, 400.0));
        // tester.view.physicalSize = const Size(600, 400);
        // addTearDown(tester.view.resetPhysicalSize);

        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(disconnected: true);
        r.expectFindDisconnectedFromBroker();
      },
    );

    testWidgets(
      '''Show ValvesWidget''',
      (tester) async {
        WidgetsBinding.instance.renderView.configuration =
            new TestViewConfiguration(size: const Size(600.0, 400.0));
        // tester.view.physicalSize = const Size(600, 400);
        // addTearDown(tester.view.resetPhysicalSize);

        final r = ProgramRobot(tester);
        await r.pumpProgramScreen();
        r.expectFindValvesWidget();
      },
    );
  });
}
