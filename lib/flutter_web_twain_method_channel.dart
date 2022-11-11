import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_web_twain_platform_interface.dart';

/// An implementation of [FlutterWebTwainPlatform] that uses method channels.
class MethodChannelFlutterWebTwain extends FlutterWebTwainPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_web_twain');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
