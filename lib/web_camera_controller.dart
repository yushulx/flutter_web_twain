import 'dart:async';
import 'dart:html' as html;
import 'shims/dart_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'web_twain_manager.dart';

enum WebCameraFacing { front, back, next, next2 }

enum WebCameraOutputFormat { png, bytes }

class WebCameraController {
  WebTwainManager _webTwainManager = WebTwainManager();
  final String _webviewId =
      'WebCamera-${DateTime.now().millisecondsSinceEpoch}';
  String get webviewId => _webviewId;

  Size? _webviewVideoSize;
  Size? get webviewVideoSize => _webviewVideoSize;

  // The video stream. Will be initialized later to see which camera needs to be used.
  html.MediaStream? _localStream;
  final html.VideoElement _videoElement = html.VideoElement();
  final html.SelectElement _selectElement = html.SelectElement();
  final html.DivElement _twainContainer = html.DivElement();
  final html.DivElement _vidDiv = html.DivElement();

  // Timer used to capture frames to be analyzed
  Timer? _frameInterval;

  int get height => 720;

  int get width => 1280;

  //
  // Lifecycle
  //

  getDevices() async {
    List<String> ids = [];
    final List<dynamic>? devices =
        await html.window.navigator.mediaDevices?.enumerateDevices();
    if (devices == null) {
      throw Exception('No devices found');
    } else {
      int index = 0;
      for (dynamic element in devices) {
        index += 1;
        ids.add(element.deviceId);
        print(element.deviceId);
        html.OptionElement option = html.OptionElement();
        option.label = element.deviceId;
        _selectElement.add(option, null);
      }
    }

    return ids;
  }

  Future<void> init(
      {required WebCameraFacing facing,
      required bool streamImages,
      required WebCameraOutputFormat format,
      Function(List<int>?)? onImage}) async {
    // _vidDiv.children = [_selectElement, _videoElement, _twainContainer];
    _twainContainer.style.width = '${640}px';
    _twainContainer.style.height = '${480}px';
    _vidDiv.children = [_twainContainer];

    ui.platformViewRegistry.registerViewFactory(
      _webviewId,
      (int id) => _vidDiv
        ..style.width = '100%'
        ..style.height = '100%',
    );

    _webTwainManager.init();
    _twainContainer.id = 'dwtcontrolContainer';
    _webTwainManager.createContainer(_twainContainer);
    // Check if stream is running
    if (_localStream != null) {
      _webviewVideoSize = Size(
        _videoElement.videoWidth.toDouble(),
        _videoElement.videoHeight.toDouble(),
      );
    }
    try {
      List<String> ids = await getDevices();

      final Map? capabilities =
          html.window.navigator.mediaDevices?.getSupportedConstraints();
      print("Capabilities : $capabilities");
      Map<String, dynamic> constraints = {
        'video': {
          'deviceId': ids[1],
          "focusMode": {"ideal": "continuous"},
          "width": {"ideal": width},
          "height": {"ideal": height},
          "frameRate": {"ideal": 20, "max": 20},
          "zoom": {"ideal": 1.2}
        },
      };
      if (capabilities?['facingMode'] as bool? ?? false) {
        constraints["video"]["facingMode"] = {
          "ideal": facing == WebCameraFacing.front ? 'user' : 'environment',
        };
      }
      print("Applied constraints : $constraints");
      _localStream =
          await html.window.navigator.mediaDevices?.getUserMedia(constraints);
      // await getDevices();
      _videoElement.srcObject = _localStream;
      // required to tell iOS safari we don't want fullscreen
      _videoElement.setAttribute('playsinline', 'true');
      await _videoElement.play();
      _webviewVideoSize = Size(
        _videoElement.videoWidth.toDouble(),
        _videoElement.videoHeight.toDouble(),
      );
      _frameInterval =
          Timer.periodic(const Duration(milliseconds: 800), (timer) {
        takePicture(format).then((value) {
          if (onImage != null) onImage(value);
        });
      });
    } catch (e) {
      throw PlatformException(code: 'WebCameraController', message: '$e');
    }
  }

  void dispose() {
    try {
      // Stop the camera stream
      _localStream?.getTracks().forEach((track) {
        if (track.readyState == 'live') {
          track.stop();
        }
      });
    } catch (e) {
      debugPrint('Failed to stop stream: $e');
    }
    _frameInterval?.cancel();
    _videoElement.srcObject = null;
    _localStream = null;
  }

  //
  // Action
  //

  Future<List<int>> takePicture(WebCameraOutputFormat format) async {
    final canvas = html.CanvasElement(
        width: _videoElement.videoWidth, height: _videoElement.videoHeight);
    canvas.context2D.drawImage(_videoElement, 0, 0);

    if (format == WebCameraOutputFormat.bytes) {
      final html.ImageData data = canvas.context2D.getImageData(
          0, 0, _videoElement.videoWidth, _videoElement.videoHeight);
      // print(data.data.sublist(0, 20));
      return Uint8List.fromList(data.data.toList());
    }

    html.Blob blob = await canvas.toBlob();
    html.FileReader reader = html.FileReader();
    reader.readAsArrayBuffer(blob);
    await reader.onLoadEnd.first;
    return (reader.result as Uint8List).toList();
  }
}
