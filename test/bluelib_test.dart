import 'package:flutter_test/flutter_test.dart';
import 'package:bluelib/bluelib.dart';
import 'package:bluelib/bluelib_platform_interface.dart';
import 'package:bluelib/bluelib_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBluelibPlatform
    with MockPlatformInterfaceMixin
    implements BluelibPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BluelibPlatform initialPlatform = BluelibPlatform.instance;

  test('$MethodChannelBluelib is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBluelib>());
  });

  test('getPlatformVersion', () async {
    Bluelib bluelibPlugin = Bluelib();
    MockBluelibPlatform fakePlatform = MockBluelibPlatform();
    BluelibPlatform.instance = fakePlatform;

    expect(await bluelibPlugin.getPlatformVersion(), '42');
  });
}
