import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/data/bluetooth_repository.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_controller.dart';

import '../../../../../robot.dart';

void main() {
  testWidgets('bluetooth connection screen ...', (tester) async {
    // final repository = MockBluetoothRepository();

    // final container = ProviderContainer();
    // final controller = container.read(bluetoothControllerProvider.notifier);
    // final r = Robot(tester: tester);
    // await r.pumpBluetoothConnectionScreen();
    // await tester.pumpAndSettle();

    // when(() => repository.scanStream)
    //     .thenAnswer((_) => Stream<List<MockScanResult>>.value([]));

    // expectLater(controller.state, emitsAnyOf([const AsyncLoading<void>()]));
  });
}

