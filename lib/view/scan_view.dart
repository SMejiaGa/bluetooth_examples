import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:bluetooth_example/model/bluetooth_helper.dart';

import 'chat_view.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  var btManager = BluetoothManager();
  List devices = [];

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    btManager.bluetoothScan().then((_) {
      setState(() {
        devices = btManager.devices;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dispositivos Escaneados")),
      body: devices.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          var device = devices[index];
          return ListTile(
            title: Text(device.name),
            subtitle: Text(device.id.toString()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatView(device: device),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
