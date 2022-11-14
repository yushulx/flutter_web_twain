import 'dart:async';
import 'dart:html' as html;
import 'shims/dart_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'web_twain_manager.dart';

class WebTwainController {
  final WebTwainManager _webTwainManager = WebTwainManager();
  final String _webviewId = '${DateTime.now().millisecondsSinceEpoch}';
  String get webviewId => _webviewId;

  final html.DivElement _twainContainer = html.DivElement();
  final html.DivElement _vidDiv = html.DivElement();

  Future<void> init() async {
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
  }

  void dispose() {}
}
