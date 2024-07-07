import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluelib_method_channel.dart';

abstract class BluelibPlatform extends PlatformInterface {
  /// Constructs a BluelibPlatform.
  BluelibPlatform() : super(token: _token);

  static final Object _token = Object();

  static BluelibPlatform _instance = MethodChannelBluelib();

  /// The default instance of [BluelibPlatform] to use.
  ///
  /// Defaults to [MethodChannelBluelib].
  static BluelibPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BluelibPlatform] when
  /// they register themselves.
  static set instance(BluelibPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
