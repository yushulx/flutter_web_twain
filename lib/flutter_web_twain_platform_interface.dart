import 'package:flutter_web_twain/web_camera_controller.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_web_twain_method_channel.dart';

abstract class FlutterWebTwainPlatform extends PlatformInterface {
  /// Constructs a FlutterWebTwainPlatform.
  FlutterWebTwainPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterWebTwainPlatform _instance = MethodChannelFlutterWebTwain();

  /// The default instance of [FlutterWebTwainPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterWebTwain].
  static FlutterWebTwainPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterWebTwainPlatform] when
  /// they register themselves.
  static set instance(FlutterWebTwainPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  WebCameraController getCameraController() {
    throw UnimplementedError('getCameraController() has not been implemented.');
  }
}
