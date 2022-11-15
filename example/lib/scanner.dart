import 'package:flutter/services.dart';
import 'package:flutter_web_twain/flutter_web_twain.dart';
import 'package:flutter_web_twain/web_twain_controller.dart';
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
  PixelFormat? _pixelFormat = PixelFormat.TWPT_BW;
  FileFormat? _fileFormat = FileFormat.PDF;
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
    _controller = await _flutterWebTwain.createWebTwainController();
    await _controller!.init('node_modules/dwt/dist/',
        't01529gIAAEF7y96DFtTsdlAY26PrA+PaDHGza3MBVgONeEy5epB0gDaCfTXfDdj889kjxcmeUTqFggXqmXQiD6HCOpbc6nEbarlhTAxuLtq7kk0SDL/A3YEOgFhkD/yVH9D1czurEABnQBPg3fgDjkN+e8WTkBFwBjQBxyEDmHSy2TfJQ0HbCElTwBnQBIyQAdQqVJqUJymPngM=');
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
            Expanded(
              child: _controller == null
                  ? const CircularProgressIndicator()
                  : HtmlElementView(viewType: _controller!.webviewId),
            ),
            SizedBox(
              child: Row(children: <Widget>[
                Radio(
                  value: PixelFormat.TWPT_BW,
                  groupValue: _pixelFormat,
                  onChanged: (PixelFormat? value) {
                    setState(() {
                      _pixelFormat = value;
                    });
                  },
                ),
                const Text('BW'),
                Radio(
                  value: PixelFormat.TWPT_GRAY,
                  groupValue: _pixelFormat,
                  onChanged: (PixelFormat? value) {
                    setState(() {
                      _pixelFormat = value;
                    });
                  },
                ),
                const Text('Gray'),
                Radio(
                  value: PixelFormat.TWPT_RGB,
                  groupValue: _pixelFormat,
                  onChanged: (PixelFormat? value) {
                    setState(() {
                      _pixelFormat = value;
                    });
                  },
                ),
                const Text('Color'),
                const Padding(padding: EdgeInsets.all(10)),
                MaterialButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () async {
                      if (_controller != null) {
                        await _controller!.scan(
                            '{"IfShowUI": false, "PixelType": ${_pixelFormat!.index}}');
                      }
                    },
                    child: const Text('Scan Documents')),
                const Padding(padding: EdgeInsets.all(10)),
                MaterialButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () async {
                      if (_controller != null) {
                        await _controller!.load();
                      }
                    },
                    child: const Text('Load Documents'))
              ]),
            ),
            SizedBox(
              height: 100,
              child: Row(children: <Widget>[
                Radio(
                  value: FileFormat.PDF,
                  groupValue: _fileFormat,
                  onChanged: (FileFormat? value) {
                    setState(() {
                      _fileFormat = value;
                    });
                  },
                ),
                const Text('PDF'),
                Radio(
                  value: FileFormat.TIFF,
                  groupValue: _fileFormat,
                  onChanged: (FileFormat? value) {
                    setState(() {
                      _fileFormat = value;
                    });
                  },
                ),
                const Text('TIFF'),
                Radio(
                  value: FileFormat.JPEG,
                  groupValue: _fileFormat,
                  onChanged: (FileFormat? value) {
                    setState(() {
                      _fileFormat = value;
                    });
                  },
                ),
                const Text('JPEG'),
                const Padding(padding: EdgeInsets.all(10)),
                MaterialButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () async {
                      if (_controller != null) {
                        await _controller!
                            .download(_fileFormat!.index, 'filename');
                      }
                    },
                    child: const Text('Download Documents')),
              ]),
            ),
          ])),
    );
  }
}
