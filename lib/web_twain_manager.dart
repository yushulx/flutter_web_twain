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
  external static set Containers(List<dynamic> containers);
  external static dynamic GetWebTwain(String containerId);
  external static void CreateDWTObjectEx(
      dynamic obj, Function success, Function error);
}

class WebTwainManager {
  dynamic _webTwain;
  String _containerId = '';
  html.Element? _container;

  init() {
    DWT.ResourcesPath = 'node_modules/dwt/dist/';
    DWT.ProductKey =
        't01529gIAAEF7y96DFtTsdlAY26PrA+PaDHGza3MBVgONeEy5epB0gDaCfTXfDdj889kjxcmeUTqFggXqmXQiD6HCOpbc6nEbarlhTAxuLtq7kk0SDL/A3YEOgFhkD/yVH9D1czurEABnQBPg3fgDjkN+e8WTkBFwBjQBxyEDmHSy2TfJQ0HbCElTwBnQBIyQAdQqVJqUJymPngM=';
  }

  createContainer(html.DivElement container) {
    _container = container;
    _containerId = container.id;
    DWT.RegisterEvent('OnWebTwainReady', allowInterop(() {
      print('OnWebTwainReady');
      _webTwain = DWT.GetWebTwain(_containerId);
      if (_webTwain == null) {
        var tmp = Map<dynamic, dynamic>();
        String jsonStr = '{"WebTwainId":"' + _containerId + '"}';
        DWT.CreateDWTObjectEx(parse(jsonStr), allowInterop((obj) {
          _webTwain = obj;
          _webTwain.IfShowUI = false;
          dynamic viewer = _webTwain.Viewer;
          if (_container != null) {
            viewer.bind(_container);
            viewer.show();

            _webTwain.OpenSource();
            _webTwain.AcquireImage({}, () {
              print("Successful!");
            }, (settings, errCode, errString) {
              alert(errString);
            });
          }
        }), allowInterop((error) {
          print('CreateDWTObjectEx error: $error');
        }));
      }
    }));
    var tmp = Map<dynamic, dynamic>();
    tmp['ContainerId'] = container.id;
    // tmp['Width'] = 600;
    // tmp['Height'] = 800;
    DWT.Containers = [tmp];
    DWT.Load();
  }
}
