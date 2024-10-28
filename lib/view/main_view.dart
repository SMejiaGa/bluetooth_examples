import 'package:bluetooth_example/model/bluetooth_helper.dart';
import 'package:bluetooth_example/view/scan_view.dart';
import 'package:flutter/material.dart';

class BluetoothApp extends StatelessWidget {
  const BluetoothApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BluetoothWidget(),
    );
  }
}

class BluetoothWidget extends StatefulWidget {
  const BluetoothWidget({super.key});

  @override
  BluetoothWidgetState createState() => BluetoothWidgetState();
}

class BluetoothWidgetState extends State<BluetoothWidget> {
  var btManager = BluetoothManager();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void bluetoothPipeline() {
    btManager.bluetoothOnOff().then((value) => {
          btManager.bluetoothInitialize().whenComplete(
              () => {btManager.bluetoothScan().then((value) => {})})
        });
  }

  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Scanner'),
      ),
      body: ListView.builder(
        itemCount: btManager.devices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(btManager.devices[index].name),
            subtitle: Text(btManager.devices[index].id.toString()),
          );
        },
      ),
    );
  }
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bluetooth Test")),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                child: const Text('Bluetooth ON/OFF'),
                onPressed: () {
                  btManager.bluetoothOnOff().then((value) => {
                        value == 0
                            ? showMessage("Bluetooth is not allowed.")
                            : showMessage(("Bluetooth ON"))
                      });
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                child: const Text('Bluetooth INITIALIZE'),
                onPressed: () {
                  btManager.bluetoothInitialize().then((value) => {
                        showMessage(value),
                      });
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                child: const Text('Bluetooth SCAN'),
                onPressed: () {
                  btManager.bluetoothScan().then((value) {
                    showMessage("Bluetooth Scan Complete.");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScanView()),
                    );
                  });
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  void showMessage(String message) {
    var snackBar = SnackBar(
      content: Text(message),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
