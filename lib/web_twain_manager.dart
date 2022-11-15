@JS('Dynamsoft')
library dynamsoft;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:js/js.dart';
import 'dart:html' as html;

import 'utils.dart';

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

class WebTwainManager {
  dynamic _webTwain;
  String _containerId = '';
  html.Element? _container;

  init(String path, String key) {
    DWT.ResourcesPath = path;
    DWT.ProductKey = key;
    DWT.AutoLoad = false;
    // DWT.ResourcesPath = 'node_modules/dwt/dist/';
    // DWT.ProductKey =
    //     't01529gIAAEF7y96DFtTsdlAY26PrA+PaDHGza3MBVgONeEy5epB0gDaCfTXfDdj889kjxcmeUTqFggXqmXQiD6HCOpbc6nEbarlhTAxuLtq7kk0SDL/A3YEOgFhkD/yVH9D1czurEABnQBPg3fgDjkN+e8WTkBFwBjQBxyEDmHSy2TfJQ0HbCElTwBnQBIyQAdQqVJqUJymPngM=';
  }

  dispose() {
    DWT.Unload();
  }

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
}
