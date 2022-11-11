import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_twain/flutter_web_twain_method_channel.dart';

void main() {
  MethodChannelFlutterWebTwain platform = MethodChannelFlutterWebTwain();
  const MethodChannel channel = MethodChannel('flutter_web_twain');

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
