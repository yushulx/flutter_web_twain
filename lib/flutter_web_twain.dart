import 'flutter_web_twain_platform_interface.dart';
import 'web_twain_controller.dart';

class FlutterWebTwain {
  Future<String?> getPlatformVersion() {
    return FlutterWebTwainPlatform.instance.getPlatformVersion();
  }

  WebTwainController getCameraController() {
    return FlutterWebTwainPlatform.instance.getCameraController();
  }
}
