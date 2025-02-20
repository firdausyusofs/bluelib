import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bluelib/bluelib_method_channel.dart';

void main() {
  MethodChannelBluelib platform = MethodChannelBluelib();
  const MethodChannel channel = MethodChannel('bluelib');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
