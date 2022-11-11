import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_twain/flutter_web_twain.dart';
import 'package:flutter_web_twain/flutter_web_twain_platform_interface.dart';
import 'package:flutter_web_twain/flutter_web_twain_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterWebTwainPlatform
    with MockPlatformInterfaceMixin
    implements FlutterWebTwainPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterWebTwainPlatform initialPlatform = FlutterWebTwainPlatform.instance;

  test('$MethodChannelFlutterWebTwain is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterWebTwain>());
  });

  test('getPlatformVersion', () async {
    FlutterWebTwain flutterWebTwainPlugin = FlutterWebTwain();
    MockFlutterWebTwainPlatform fakePlatform = MockFlutterWebTwainPlatform();
    FlutterWebTwainPlatform.instance = fakePlatform;

    expect(await flutterWebTwainPlugin.getPlatformVersion(), '42');
  });
}
