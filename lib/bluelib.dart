
import 'package:bluelib/device_info.dart';
import 'package:flutter/services.dart';

import 'bluelib_platform_interface.dart';

class Bluelib {
    static const MethodChannel _channel = const MethodChannel('bluelib');
    static const EventChannel _eventChannel = const EventChannel('bluelib/events');

    static Future<void> startScan() async {
        await _channel.invokeMethod('startScan');
    }

    static Future<void> stopScan() async {
        await _channel.invokeMethod('stopScan');
    }

    static Stream<DeviceInfo?> get scannedDevices {
      return _eventChannel
                .receiveBroadcastStream()
                .map((event) => DeviceInfo.fromMap(Map<String, dynamic>.from(event)));
    }
}
