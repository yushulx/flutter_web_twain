import 'dart:async';
import 'dart:html' as html;
import 'shims/dart_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'web_twain_manager.dart';

/// WebTwainController class.
class WebTwainController {
  final WebTwainManager _webTwainManager = WebTwainManager();
  final String _webviewId = '${DateTime.now().millisecondsSinceEpoch}';
  String get webviewId => _webviewId;
  final html.DivElement _twainContainer = html.DivElement();

  /// Initialize the controller.
  Future<void> init(String path, String key) async {
    ui.platformViewRegistry.registerViewFactory(
      _webviewId,
      (int id) => _twainContainer
        ..style.width = '100%'
        ..style.height = '100%',
    );

    _webTwainManager.init(path, key);
    _twainContainer.id = 'dwtcontrolContainer';
    _webTwainManager.createContainer(_twainContainer);
  }

  /// Destroy the controller.
  Future<void> dispose() async {
    _webTwainManager.dispose();
  }

  /// Scan a document.
  Future<void> scan(String config) async {
    _webTwainManager.scan(config);
  }

  /// Load a document.
  Future<void> load() async {
    _webTwainManager.load();
  }

  /// Save a document.
  Future<void> download(int type, String filename) async {
    _webTwainManager.download(type, filename);
  }
}
