import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/data/bluetooth_repository.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/domain/wifi_network.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/presentation/bluetooth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../commons.dart';
import '../../../mocks.dart';
import '../../../partial_mock_bluetoothcontroller_for_testing.dart';

void main() {
  late MockBluetoothRepository repository;
  setUp(() {
    repository = MockBluetoothRepository();
  });
  test(
      'bluetooth controller initial state is AsyncLoading. If not found device state is AsyncData(_firstWhereOrNull)',
      () async {
    // setup
    final container = ProviderContainer(
        overrides: [bluetoothRepositoryProvider.overrideWithValue(repository)]);

    final controller = container.read(bluetoothControllerProvider.notifier);

    // creating  a ScanResult
    const id = DeviceIdentifier('raspirriv1');
    final device = BluetoothDevice(
      remoteId: id,
    );
    DateTime fakeDateTime = DateTime(2023, 8, 15, 12, 30, 45, 500);
    final data = AdvertisementData(
        advName: 'raspirriv1',
        txPowerLevel: 2,
        connectable: true,
        manufacturerData: {},
        serviceData: {},
        serviceUuids: []);

    final scanResult = ScanResult(
        device: device, advertisementData: data, rssi: 1, timeStamp: fakeDateTime);

    when(() => repository.scanStream)
        .thenAnswer((_) => Stream<List<ScanResult>>.value([scanResult]));

    when(repository.stopScan).thenAnswer((_) => Future.value());

    // verify
    expectLater(
        controller.stream,
        emitsInOrder([
          const AsyncLoading<BluetoothDevice?>(),
          const AsyncData<BluetoothDevice?>(null)
        ]));

    // run
    await controller.startScanStream();
    addTearDown(() => container.dispose());
  });

  test('stopScan method calls repositorys stopScan() method', () async {
    // setup
    final container = ProviderContainer(
        overrides: [bluetoothRepositoryProvider.overrideWithValue(repository)]);

    when(repository.stopScan).thenAnswer((_) => Future.value());
    final controller = container.read(bluetoothControllerProvider.notifier);

    // run
    controller.stopScan();
    // verify
    verify(() => repository.stopScan()).called(1);
  });

  test('connectDevice method calls repositorys connectDevice() method', () async {
    // setup
    var container = ProviderContainer(
        overrides: [bluetoothRepositoryProvider.overrideWithValue(repository)]);

    final controller = container.read(bluetoothControllerProvider.notifier);

    when(() => repository.stopScan()).thenAnswer((_) => Future.value());

    // run
    controller.stopScan();
    // verify
    verify(() => repository.stopScan()).called(1);
  });

  test('watchConnectionChanges method calls repositorys connectionStateGhanges() method',
      () async {
    // setup
    const id = DeviceIdentifier('raspirriv1');
    final device = BluetoothDevice(
      remoteId: id,
    );
    registerFallbackValue(device);
    var container = ProviderContainer(
        overrides: [bluetoothRepositoryProvider.overrideWithValue(repository)]);

    final controller = container.read(bluetoothControllerProvider.notifier);

    controller.device = device;

    when(() => repository.connectionStateGhanges(device))
        .thenAnswer((_) => Stream.value(BluetoothConnectionState.connected));

    // run
    controller.watchConnectionChanges();
    // verify
    verify(() => repository.connectionStateGhanges(any())).called(1);
  });

  test('readFromDevice method calls repositorys readFromCharacteristic() method',
      () async {
    // setup
    final char = fakeBluetoothCharacteristic;

    var container = ProviderContainer(
        overrides: [bluetoothRepositoryProvider.overrideWithValue(repository)]);

    final controller = container.read(bluetoothControllerProvider.notifier);

    controller.mainCharacteristic = char;

    when(() => repository.readFromCharacteristic(char))
        .thenAnswer((_) => Future.value([1, 2, 3]));

    // run
    await controller.readFromDevice(char);
    // verify
    verify(() => repository.readFromCharacteristic(char)).called(1);
  });

  test('readFromDevice method if mainCharacteristic is null return []', () async {
    // setup

    final char = fakeBluetoothCharacteristic;

    var container = ProviderContainer(
        overrides: [bluetoothRepositoryProvider.overrideWithValue(repository)]);

    final controller = container.read(bluetoothControllerProvider.notifier);

    controller.mainCharacteristic = null;

    when(() => repository.readFromCharacteristic(char))
        .thenAnswer((_) => Future.value([1, 2, 3]));

    // run
    final result = await controller.readFromDevice(char);
    // verify
    verifyNever(() => repository.readFromCharacteristic(char));
    expect(result, []);
  });

  test('writeToDevice method calls repositorys writeToCharacteristic() method', () async {
    // setup
    final char = fakeBluetoothCharacteristic;

    var container = ProviderContainer(
        overrides: [bluetoothRepositoryProvider.overrideWithValue(repository)]);

    final controller = container.read(bluetoothControllerProvider.notifier);

    controller.mainCharacteristic = char;

    const data = 'data';
    final formatedData = utf8.encode(data);

    when(() => repository.writeToCharacteristic(
        controller.mainCharacteristic!, formatedData)).thenAnswer((_) => Future.value());

    // run
    await controller.writeToDevice('data');
    // verify
    verify(() => repository.writeToCharacteristic(
        controller.mainCharacteristic!, formatedData)).called(1);
  });

  test('Fetch networks', () async {
    // setup
    final char = fakeBluetoothCharacteristic;

    SharedPreferences.setMockInitialValues({
      'hwId': '',
      'mqtt_host': '',
      'mqtt_port': '',
      'mqtt_user': '',
      'mqtt_pass': '',
    });

    var container = ProviderContainer(
        overrides: [bluetoothRepositoryProvider.overrideWithValue(repository)]);

    var ref = container.readProviderElement(bluetoothControllerProvider);

    final controller = PartialMockBluetoothControllerForTesting(repository, ref);

    controller.mainCharacteristic = char;

    const data = 'data';
    final formatedData = utf8.encode(data);

    when(() => repository.writeToCharacteristic(
        controller.mainCharacteristic!, formatedData)).thenAnswer((_) => Future.value());

    final expected = [WifiNetwork(1, 'myNetwork', ''), WifiNetwork(1, 'myNetwork', '')];
    // run
    final result = await controller.fetchNetworks(char);
    // verify
    expect(result, expected);
  });

  test('sendNetworkCredentialsToDevice', () async {
    // setup
    final char = fakeBluetoothCharacteristic;

    var container = ProviderContainer(
        overrides: [bluetoothRepositoryProvider.overrideWithValue(repository)]);

    var ref = container.readProviderElement(bluetoothControllerProvider);

    final controller = PartialMockBluetoothControllerForTesting(repository, ref);

    controller.mainCharacteristic = char;

    const data = 'data';
    final formatedData = utf8.encode(data);

    when(() => repository.writeToCharacteristic(
        controller.mainCharacteristic!, formatedData)).thenAnswer((_) => Future.value());

    final expected = [WifiNetwork(1, 'myNetwork', ''), WifiNetwork(1, 'myNetwork', '')];
    // run
    final result = await controller.fetchNetworks(char);
    // verify
    expect(result, expected);
  });

  test('Test ssidProvider', () {
    // setup
    final container = ProviderContainer();
    container.read(ssidProvider.notifier).state = 'test';
    // verify
    expect(container.read(ssidProvider), 'test');
  });

  test('Test passwordProvider', () {
    // setup
    final container = ProviderContainer();
    container.read(passwordProvider.notifier).state = 'password';
    // verify
    expect(container.read(passwordProvider), 'password');
  });
}
