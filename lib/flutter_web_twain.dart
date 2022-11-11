
import 'flutter_web_twain_platform_interface.dart';

class FlutterWebTwain {
  Future<String?> getPlatformVersion() {
    return FlutterWebTwainPlatform.instance.getPlatformVersion();
  }
}
