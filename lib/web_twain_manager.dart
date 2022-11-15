@JS('Dynamsoft')
library dynamsoft;

import 'package:js/js.dart';
import 'dart:html' as html;
import 'utils.dart';

/// DWT class.
@JS('DWT')
class DWT {
  external static set ResourcesPath(String resourcePath);
  external static set ProductKey(String productKey);
  external static void Load();
  external static void Unload();
  external static void CreateDWTObjectEx(
      dynamic obj, Function success, Function error);
  external static set AutoLoad(bool autoLoad);
}

@JS('DWTObject')
class DWTObject {
  external set IfShowUI(bool ifShowUI);
  external dynamic get Viewer;
  external void OpenSource();
  external void CloseSource();
  external void AcquireImage(dynamic obj, Function success, Function error);
  external void LoadImageEx(
      String path, int type, Function success, Function error);
  external int get HowManyImagesInBuffer;
  external set IfShowFileDialog(bool ifShowFileDialog);
  external int get CurrentImageIndexInBuffer;
  external void SaveAllAsPDF(String path, Function success, Function error);
  external void SaveAllAsMultiPageTIFF(
      String path, Function success, Function error);
  external void SaveAsJPEG(String path, int index);
  external int GetImageBitDepth(int index);
  external void ConvertToGrayScale(int index);
}

@JS('Viewer')
class Viewer {
  external void bind(dynamic container);
  external void show();
}

/// WebTwainManager class.
class WebTwainManager {
  DWTObject? _webTwain;
  String _containerId = '';
  html.Element? _container;

  /// Configure Web TWAIN SDK.
  init(String path, String key) {
    DWT.ResourcesPath = path;
    DWT.ProductKey = key;
    DWT.AutoLoad = false;
  }

  /// Release resources.
  dispose() {
    DWT.Unload();
  }

  /// Scan documents.
  scan(String config) {
    if (_webTwain != null) {
      _webTwain!.OpenSource();
      _webTwain!.AcquireImage(parse(config), allowInterop(() {
        _webTwain!.CloseSource();
      }), allowInterop((settings, errCode, errString) {
        _webTwain!.CloseSource();
        print(errString);
      }));
    }
  }

  /// Create a container for displaying images.
  createContainer(html.DivElement container) {
    _container = container;
    _containerId = container.id;
    var tmp = Map<dynamic, dynamic>();
    String jsonStr = '{"WebTwainId":"container"}';
    DWT.Unload();
    DWT.CreateDWTObjectEx(parse(jsonStr), allowInterop((DWTObject obj) {
      _webTwain = obj;
      _webTwain!.IfShowUI = false;
      Viewer viewer = _webTwain!.Viewer;
      if (_container != null) {
        viewer.bind(_container);
        viewer.show();
      }
    }), allowInterop((error) {
      print('CreateDWTObjectEx error: $error');
    }));
  }

  /// Load images.
  load() {
    if (_webTwain != null) {
      _webTwain!.LoadImageEx("", 5, allowInterop(() {
        print("Successful!");
      }), allowInterop((errorCode, errorString) {
        alert(errorString);
      }));
    }
  }

  /// Download images.
  download(int type, String filename) {
    if (_webTwain != null && _webTwain!.HowManyImagesInBuffer > 0) {
      _webTwain!.IfShowFileDialog = true;
      switch (type) {
        case 0:
          _webTwain!.SaveAllAsPDF(
              filename, allowInterop(() => {}), allowInterop(() => {}));
          break;
        case 1:
          _webTwain!.SaveAllAsMultiPageTIFF(
              filename, allowInterop(() => {}), allowInterop(() => {}));
          break;
        case 2:
          if (_webTwain!
                  .GetImageBitDepth(_webTwain!.CurrentImageIndexInBuffer) ==
              1) {
            _webTwain!.ConvertToGrayScale(_webTwain!.CurrentImageIndexInBuffer);
          }
          _webTwain!.SaveAsJPEG(filename, _webTwain!.CurrentImageIndexInBuffer);
      }
    }
  }
}
