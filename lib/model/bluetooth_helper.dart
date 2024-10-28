import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:io' show Platform;
import 'package:logger/logger.dart';

class BluetoothManager {
  Logger logger = Logger();
  List devices = [];

  static final BluetoothManager _btManager = BluetoothManager._();

  factory BluetoothManager() {
    return _btManager;
  }

  BluetoothManager._();

  Future<int> bluetoothOnOff() async {
    var result = 0;
    if (await FlutterBluePlus.isSupported == false) {
      return result;
    }

    var subscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      if (state == BluetoothAdapterState.on) {
        result = 1;
      } else {}
    });

    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    subscription.cancel();

    return result;
  }

  Future<String> bluetoothInitialize() async {
    await FlutterBluePlus.setLogLevel(
        LogLevel.verbose); // Enable verbose logging

    await FlutterBluePlus.setOptions(showPowerAlert: true, );

    return FlutterBluePlus.adapterName;

  }

  Future<void> bluetoothScan() async {
    var subscription = FlutterBluePlus.onScanResults.listen(
      (results) {
        //logger.i(results);
        if (results.isNotEmpty) {
          ScanResult r = results.last; // the most recently found device
          logger.i(
              '${r.device.remoteId}: "${r.advertisementData.advName}" found! ${r.device.name}');
          devices.add(r.device.remoteId);
        }
      },
      onError: (e) => logger.e(e),
    );

    FlutterBluePlus.cancelWhenScanComplete(subscription);

    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;

    await FlutterBluePlus.startScan(
        //withServices: [Guid("180D")], // match any of the specified services
        //withNames: ["Bluno"], // *or* any of the specified names
        timeout: const Duration(seconds: 15));

    await FlutterBluePlus.isScanning.where((val) => val == false).first;
  }

  Future<void> bluetoothConnect(device) async {
    var subscription =
        device.connectionState.listen((BluetoothConnectionState state) async {
      if (state == BluetoothConnectionState.disconnected) {
        print(
            "${device.disconnectReason?.code} ${device.disconnectReason?.description}");
      }
    });

    device.cancelWhenDisconnected(subscription, delayed: true, next: true);

    await device.connect();

    await device.disconnect();

    subscription.cancel();
  }

  Future<void> bluetoothDeviceServices(device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.read) {
          List<int> value = await c.read();
          logger.i(value);
        }
      }
    }
  }
}
