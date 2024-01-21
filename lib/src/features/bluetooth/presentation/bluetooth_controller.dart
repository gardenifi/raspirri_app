import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_gardenifi_app/src/constants/bluetooth_constants.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/data/bluetooth_repository.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/domain/wifi_network.dart';
import 'package:new_gardenifi_app/src/features/bluetooth/domain/wifi_networks.dart';

class BluetoothController extends StateNotifier<AsyncValue<BluetoothDevice?>> {
  BluetoothController(
    this.bluetoothRepository,
    this.ref,
  ) : super(const AsyncValue.data(null));

  final Ref ref;

  final BluetoothRepository bluetoothRepository;

  BluetoothDevice? device;

  BluetoothService? service;

  BluetoothCharacteristic? mainCharacteristic;

  BluetoothCharacteristic? statusCharacteristic;

  late StreamSubscription<List<ScanResult>> _scanSubscription;

  Future<void> startScan() async => await bluetoothRepository.startScan();

  @override
  void dispose() {
    _scanSubscription.cancel();
    super.dispose();
  }

  Future<void> startScanStream() async {
    // Send to widget a loading value
    state = const AsyncValue.loading();
    // Start coundown 10 seconds. If device not found return to widget a false value
    final timer = Timer(const Duration(seconds: 15), () async {
      await bluetoothRepository.stopScan();
      state = const AsyncData(null);
    });

    // Start listening for devices
    _scanSubscription = bluetoothRepository.scanStream.listen(
      (results) async {
        if (results.isNotEmpty) {
          ScanResult result = results.last;
          // If device found: stop countdown, stop scan, cancel subscription, connect device and sent to widget the device
          if (result.device.platformName == DEVICE_NAME) {
            device = result.device;
            timer.cancel();
            await _scanSubscription.cancel();
            await bluetoothRepository.stopScan();
            await bluetoothRepository.connectDevice(device!);
            state = AsyncValue<BluetoothDevice>.data(device!);
          }
        }
      },
    );
  }

  Future<void> stopScan() async => await bluetoothRepository.stopScan();

  Future<void> connectDevice(BluetoothDevice device) async =>
      await bluetoothRepository.connectDevice(device);

  Stream<BluetoothConnectionState> watchConnectionChanges() =>
      bluetoothRepository.connectionStateGhanges(device!);

  Future<BluetoothCharacteristic?> fetchServices() async {
    var services = await bluetoothRepository.discoverServices(device!);
    for (var service in services) {
      if (service.uuid.toString() == SERVICE_UUID) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            mainCharacteristic = characteristic;
          }
          if (characteristic.uuid.toString() == STATUS_CHARASTERISTIC_UUID) {
            statusCharacteristic = characteristic;
          }
        }
      }
    }
    return mainCharacteristic;
  }

  // call repository to read data from device
  Future<List<int>> readFromDevice(BluetoothCharacteristic char) async {
    if (mainCharacteristic != null) {
      var response = await bluetoothRepository.readFromCharacteristic(char);
      return response;
    } else {
      log('Error while reading from [BluetoothController-readFromDevice]');
      return [];
    }
  }

  // Call repository to write data to device
  Future<void> writeToDevice(String data) async {
    List<int> formatedData = utf8.encode(data);
    if (mainCharacteristic != null) {
      await bluetoothRepository.writeToCharacteristic(mainCharacteristic!, formatedData);
    }
  }

  // Read networks from device
  Future<List<WifiNetwork>> fetchNetworks(
      BluetoothCharacteristic targetCharacteristic) async {
    List<WifiNetwork> listOfWifiNetwork = [];
    List<int> page1response = [];

    // request 1st page
    var i = 1;
    var newRequest = '{"page": "$i"}';
    // send request to device
    await writeToDevice(newRequest);
    // read the response from device
    page1response = await readFromDevice(mainCharacteristic!);
    String stringOfWifis = String.fromCharCodes(page1response);
    var networksFromJson = WifiNetworks.fromJson(stringOfWifis);
    listOfWifiNetwork += networksFromJson.nets;

    //  The device along with wifi networks sends mqtt credentials and the unique [hardwareId].
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('hwId', networksFromJson.hwId);
    prefs.setString('mqtt_host', networksFromJson.mqttBroker.host);
    prefs.setInt('mqtt_port', networksFromJson.mqttBroker.port);
    prefs.setString('mqtt_user', networksFromJson.mqttBroker.user);
    prefs.setString('mqtt_pass', networksFromJson.mqttBroker.pass);

    // if there are more than one pages request them
    var pages = networksFromJson.pages;

    for (int i = 2; i <= pages; i++) {
      var newRequest = '{"page": "$i"}';
      await writeToDevice(newRequest);

      List<int> newResponse = await readFromDevice(mainCharacteristic!);
      String stringOfWifis = String.fromCharCodes(newResponse);

      var networksFromJson = WifiNetworks.fromJson(stringOfWifis);
      listOfWifiNetwork += networksFromJson.nets;
    }
    return listOfWifiNetwork;
  }

  Future<String> sendNetworkCredentialsToDevice(String ssid, String password) async {
    Map<String, String> data = {'ssid': ssid, "wifi_key": password};
    String jsonData = json.encode(data);
    await writeToDevice(jsonData);
    // Device will sent back "1" if connected to internet successful or "0" if not
    await Future.delayed(const Duration(seconds: 10));
    var response = await readFromDevice(statusCharacteristic!);
    return String.fromCharCodes(response);
  }
}

//-------------> P R O V I D E R S <--------------

// / The provider of the BluetoothController class
final bluetoothControllerProvider =
    StateNotifierProvider<BluetoothController, AsyncValue<BluetoothDevice?>>((ref) {
  final bluetoothRepository = ref.watch(bluetoothRepositoryProvider);
  return BluetoothController(bluetoothRepository, ref);
});

// The provider that watch the connection of the device
final connectionProvider = StreamProvider.autoDispose<BluetoothConnectionState>((ref) {
  final connectionStream =
      ref.watch(bluetoothControllerProvider.notifier).watchConnectionChanges();
  return connectionStream;
});

final wifiNetworksFutureProvider =
    FutureProvider.autoDispose<List<WifiNetwork>>((ref) async {
  // read characteristic and then ask for networks
  final char = await ref.watch(bluetoothControllerProvider.notifier).fetchServices();
  return ref.watch(bluetoothControllerProvider.notifier).fetchNetworks(char!);
});

// The provider that watch if device connected to internet or not. If connected it return "1" else returns "0"
final wifiConnectionStatusProvider = FutureProvider<String>((ref) async {
  final ssid = ref.watch(ssidProvider);
  final password = ref.watch(passwordProvider);
  return ref
      .read(bluetoothControllerProvider.notifier)
      .sendNetworkCredentialsToDevice(ssid, password);
});

// The provider that watch the selected ssid
final ssidProvider = StateProvider<String>((ref) {
  return '';
});

// The provider that watch the given password for the selected network
final passwordProvider = StateProvider<String>((ref) {
  return '';
});

