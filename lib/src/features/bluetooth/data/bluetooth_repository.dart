import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BluetoothRepository {
  BluetoothRepository() : super();

  // The stream to watch Bluetooth adpater state
  Stream<BluetoothAdapterState> adapterStateChanges() => FlutterBluePlus.adapterState;

  // The scan results stream
  Stream<List<ScanResult>> scanStream = FlutterBluePlus.scanResults;

  // The stream to watch Bluetooth connection with device
  Stream<BluetoothConnectionState> connectionStateGhanges(BluetoothDevice device) =>
      device.connectionState;

  /// Function to turn on bluetooth adapter of mobile
  Future<void> turnBluetoothOn() async {
    FlutterBluePlus.turnOn();
  }

  /// Start scaning for devices.
  Future<void> startScan() async {
    try {
      await FlutterBluePlus.startScan();
    } catch (e) {
      throw Exception('Start Scan Error: $e');
    }
  }

  /// The function to connect to the given device
  Future<void> connectDevice(BluetoothDevice device) async {
    await device.connect();
  }

  Future<List<BluetoothService>> discoverServices(BluetoothDevice device) async {
    var services = await device.discoverServices();
    return services;
  }

  /// Function to stop scanning and cancel the stream subscription.
  Future<void> stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
    } catch (e) {
      throw Exception('Stop Scan Error: $e');
    }
  }

  Future<List<int>> readFromCharacteristic(BluetoothCharacteristic char) async {
    var result = await char.read(timeout: 60);
    return result;
  }

  Future<void> writeToCharacteristic(
      BluetoothCharacteristic char, List<int> value) async {
    try {
      await char.write(value, withoutResponse: true);
    } catch (e) {
      log('Error while writing to characteristic: ${e.toString()}');
    }
  }
}

// -------------> PROVIDERS <--------------------

// The provider of the Bluetooth repository
final bluetoothRepositoryProvider = Provider<BluetoothRepository>((ref) {
  return BluetoothRepository();
});

// The provider of the bluetooth adapter state stream
final bluetoothAdapterStateStreamProvider =
    StreamProvider.autoDispose<BluetoothAdapterState>((ref) {
  final bluetoothRepository = ref.watch(bluetoothRepositoryProvider);
  return bluetoothRepository.adapterStateChanges();
});
