import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../program_robot.dart';

void main() {
  void setLandscapeScreen(WidgetTester tester) {
    final dpi = tester.view.devicePixelRatio = 3.0;
    tester.view.physicalSize = Size(600 * dpi, 400 * dpi);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  void setPortraitScreen(WidgetTester tester) {
    final dpi = tester.view.devicePixelRatio = 3.0;
    tester.view.physicalSize = Size(360 * dpi, 800 * dpi);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  group('Portrait', () {
    testWidgets(
      '''When while fatching data from broker 
       Then show CircularProgressIndicator''',
      (tester) async {
        setPortraitScreen(tester);
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
        setPortraitScreen(tester);
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
        setPortraitScreen(tester);
        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(cantConnect: true);
        r.expectFindCanNotConnectToBrokerWidget();
      },
    );

    testWidgets(
      '''When IoT device is disconnected
       Then show DeviceDisconnectedWidget''',
      (tester) async {
        setPortraitScreen(tester);
        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(statusValue: {'err': 'LOST_CONNECTION'});
        r.expectFindDeviceDisconnectedWidget();
      },
    );

    testWidgets(
      '''When there is no valve registered
       Then show NoValvesWidget''',
      (tester) async {
        setPortraitScreen(tester);
        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(valvesList: []);
        r.expectFindNoValvesWidget();
      },
    );

    testWidgets(
      '''When disconnect from broker
       Then show DisconnectedFromBrokerWidget''',
      (tester) async {
        setPortraitScreen(tester);
        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(disconnected: true);
        r.expectFindDisconnectedFromBroker();
      },
    );

    testWidgets(
      '''Show ValvesWidget''',
      (tester) async {
        setPortraitScreen(tester);
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
        setLandscapeScreen(tester);

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
        setLandscapeScreen(tester);

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
        setLandscapeScreen(tester);

        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(cantConnect: true);
        r.expectFindCanNotConnectToBrokerWidget();
      },
    );

    testWidgets(
      '''When IoT device is disconnected
       Then show DeviceDisconnectedWidget''',
      (tester) async {
        setLandscapeScreen(tester);

        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(statusValue: {'err': 'LOST_CONNECTION'});
        r.expectFindDeviceDisconnectedWidget();
      },
    );

    // testWidgets(
    //   '''When there is no valve registered
    //    Then show NoValvesWidget''',
    //   (tester) async {
    //     final dpi = tester.view.devicePixelRatio = 3.0;
    //     tester.view.physicalSize = Size(600 * dpi, 400 * dpi);
    //     addTearDown(tester.view.resetPhysicalSize);
    //     addTearDown(tester.view.resetDevicePixelRatio);

    //     final r = ProgramRobot(tester);
    //     await r.pumpProgramScreen(valvesList: []);
    //     r.expectFindNoValvesWidget();
    //   },
    // );

    testWidgets(
      '''When disconnect from broker
       Then show DisconnectedFromBrokerWidget''',
      (tester) async {
        setLandscapeScreen(tester);

        final r = ProgramRobot(tester);
        await r.pumpProgramScreen(disconnected: true);
        r.expectFindDisconnectedFromBroker();
      },
    );

    testWidgets(
      '''Show ValvesWidget''',
      (tester) async {
        setLandscapeScreen(tester);

        final r = ProgramRobot(tester);
        await r.pumpProgramScreen();
        r.expectFindValvesWidget();
      },
    );
  });
}
