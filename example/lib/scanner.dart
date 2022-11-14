import 'package:flutter/services.dart';
import 'package:flutter_web_twain/flutter_web_twain.dart';
import 'package:flutter_web_twain/web_camera_controller.dart';
import 'package:flutter/material.dart';

class ScannerWidget extends StatefulWidget {
  const ScannerWidget({super.key});

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  final FlutterWebTwain _flutterWebTwain = FlutterWebTwain();
  WebTwainController? _controller;
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Future<void> _setup() async {
    try {
      _platformVersion = await _flutterWebTwain.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      _platformVersion = 'Failed to get platform version.';
    }
    _controller = _flutterWebTwain.getCameraController();
    await _controller!.init();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Dynamic Web TWAIN for Flutter'),
          ),
          body: Column(children: [
            SizedBox(
              height: 100,
              child: Row(children: <Widget>[
                Text(
                  _platformVersion,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                )
              ]),
            ),
            Expanded(
              child: _controller == null
                  ? const CircularProgressIndicator()
                  : HtmlElementView(viewType: _controller!.webviewId),
            ),
            SizedBox(
              height: 100,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MaterialButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () async {},
                        child: const Text('Scan Documents')),
                    MaterialButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () async {},
                        child: const Text('Save File')),
                  ]),
            ),
          ])),
    );
  }
}
