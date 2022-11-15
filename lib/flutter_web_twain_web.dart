// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'flutter_web_twain_platform_interface.dart';
import 'web_twain_controller.dart';

/// A web implementation of the FlutterWebTwainPlatform of the FlutterWebTwain plugin.
class FlutterWebTwainWeb extends FlutterWebTwainPlatform {
  /// Constructs a FlutterWebTwainWeb
  FlutterWebTwainWeb();

  static void registerWith(Registrar registrar) {
    FlutterWebTwainPlatform.instance = FlutterWebTwainWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  /// Returns a [WebTwainController] instance.
  @override
  WebTwainController createWebTwainController() {
    return WebTwainController();
  }
}
