import 'flutter_web_twain_platform_interface.dart';
import 'web_camera_controller.dart';

class FlutterWebTwain {
  Future<String?> getPlatformVersion() {
    return FlutterWebTwainPlatform.instance.getPlatformVersion();
  }

  WebCameraController getCameraController() {
    return FlutterWebTwainPlatform.instance.getCameraController();
  }
}
