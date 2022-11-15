import 'flutter_web_twain_platform_interface.dart';
import 'web_twain_controller.dart';

class FlutterWebTwain {
  Future<String?> getPlatformVersion() {
    return FlutterWebTwainPlatform.instance.getPlatformVersion();
  }

  Future<WebTwainController?> createWebTwainController() {
    return FlutterWebTwainPlatform.instance.createWebTwainController();
  }
}

/// Image pixel format.
enum PixelFormat {
  TWPT_BW,
  TWPT_GRAY,
  TWPT_RGB,
  TWPT_PALLETE,
  TWPT_CMY,
  TWPT_CMYK,
  TWPT_YUV,
  TWPT_YUVK,
  TWPT_CIEXYZ,
  TWPT_LAB,
  TWPT_SRGB,
  TWPT_SCRGB,
  TWPT_INFRARED
}

/// Image file Format.
enum FileFormat { PDF, TIFF, JPEG }
