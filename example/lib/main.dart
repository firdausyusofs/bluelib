import 'dart:async';
import 'dart:io';

import 'package:bluelib/bluelib.dart';
import 'package:bluelib/device_info.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<DeviceInfo> devices = [];

  @override
  void initState() {
    super.initState();

    Bluelib.scannedDevices.listen((device) {
      // Check if device is null
      if (device == null) {
        return;
      }

      // Check if device is already in the list
      // If it is, pop the old device and push the new one
      if (devices.any((element) => element.address == device.address)) {
        setState(() {
          devices.removeWhere((element) => element.address == device.address);
          devices.add(device);
        });
      }

      setState(() {
        devices.add(device);
      });
    });
  }

  Future<void> _generateCsvFile() async {
    List<List<String>> csvData = [
      ['Device name', 'Address', 'RSSI', 'Distance', 'Timestamp'],
      ...devices.map((device) => [
            device.deviceName,
            device.address,
            device.rssi.toString(),
            device.distance.toString(),
            device.updatedAt,
      ])
    ];

    String csv = const ListToCsvConverter().convert(csvData);
    final directory = await getApplicationDocumentsDirectory();
    // Unique file name
    final filename = '${directory.path}/devices_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File(filename);
    await file.writeAsString(csv);

    print('CSV file generated at: $filename');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bluelib app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Bluelib.startScan();
                },
                child: const Text('Start scan'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await Bluelib.stopScan();

                  // Generate csv file
                  await _generateCsvFile();

                  // Clear the list
                  setState(() {
                    devices.clear();
                  });
                },
                child: const Text('Stop scan'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(devices[index].deviceName),
                      subtitle: Text(
                          'RSSI: ${devices[index].rssi}, Distance: ${devices[index].distance} meters'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
