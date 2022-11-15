@JS('Dynamsoft')
library dynamsoft;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:js/js.dart';
import 'dart:html' as html;

import 'utils.dart';

/// DWT class.
@JS('DWT')
class DWT {
  external static set ResourcesPath(String resourcePath);
  external static set ProductKey(String productKey);
  external static void RegisterEvent(String event, Function func);
  external static void Load();
  external static void Unload();
  external static set Containers(List<dynamic> containers);
  external static dynamic GetWebTwain(String containerId);
  external static void CreateDWTObjectEx(
      dynamic obj, Function success, Function error);
  external static set AutoLoad(bool autoLoad);
}

/// WebTwainManager class.
class WebTwainManager {
  dynamic _webTwain;
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
      _webTwain.OpenSource();
      _webTwain.AcquireImage(parse(config), () {
        print("Successful!");
      }, (settings, errCode, errString) {
        alert(errString);
      });
    }
  }

  /// Create a container for displaying images.
  createContainer(html.DivElement container) {
    _container = container;
    _containerId = container.id;
    var tmp = Map<dynamic, dynamic>();
    String jsonStr = '{"WebTwainId":"container"}';
    DWT.Unload();
    DWT.CreateDWTObjectEx(parse(jsonStr), allowInterop((obj) {
      _webTwain = obj;
      _webTwain.IfShowUI = false;
      dynamic viewer = _webTwain.Viewer;
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
      _webTwain.LoadImageEx("", 5, () {
        print("Successful!");
      }, (errorCode, errorString) {
        alert(errorString);
      });
    }
  }

  /// Download images.
  download(int type, String filename) {
    if (_webTwain != null && _webTwain.HowManyImagesInBuffer > 0) {
      _webTwain.IfShowFileDialog = true;
      switch (type) {
        case 0:
          _webTwain.SaveAllAsPDF(filename, () => {}, () => {});
          break;
        case 1:
          _webTwain.SaveAllAsMultiPageTIFF(filename, () => {}, () => {});
          break;
        case 2:
          if (_webTwain.GetImageBitDepth(_webTwain.CurrentImageIndexInBuffer) ==
              1) {
            _webTwain.ConvertToGrayScale(_webTwain.CurrentImageIndexInBuffer);
          }
          _webTwain.SaveAsJPEG(filename, _webTwain.CurrentImageIndexInBuffer);
      }
    }
  }
}
