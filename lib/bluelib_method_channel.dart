import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bluelib_platform_interface.dart';

/// An implementation of [BluelibPlatform] that uses method channels.
class MethodChannelBluelib extends BluelibPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bluelib');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
