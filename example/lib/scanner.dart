import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_web_twain/flutter_web_twain.dart';
import 'package:flutter_web_twain/web_camera_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_sdk/dynamsoft_barcode.dart';
import 'package:flutter_barcode_sdk/flutter_barcode_sdk.dart';

class ScannerWidget extends StatefulWidget {
  const ScannerWidget({Key? key, required this.onScannedCodes})
      : super(key: key);

  final Function(List<String>) onScannedCodes;

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  final FlutterWebTwain _flutterWebTwain = FlutterWebTwain();
  WebCameraController? _controller;
  final FlutterBarcodeSdk _dynamsoft = FlutterBarcodeSdk();

  final String _dynamsoftParameters =
      r'{"ImageParameter": {"BarcodeFormatIds": ["BF_ALL"],"BarcodeFormatIds_2": ["BF2_NULL"],"DeblurLevel": 9,"DeblurModes": [{"Mode": "DM_DEEP_ANALYSIS"}],"Description": "","ExpectedBarcodesCount": 2,"LocalizationModes": [{"IsOneDStacked": 0,"LibraryFileName": "","LibraryParameters": "","Mode": "LM_SCAN_DIRECTLY","ScanDirection": 0, "ScanStride": 0},{"LibraryFileName": "","LibraryParameters": "","Mode": "LM_CONNECTED_BLOCKS"}],"ImagePreprocessingModes": [{"LibraryFileName": "","LibraryParameters": "","Mode": "IPM_GRAY_SMOOTH"},{"LibraryFileName": "","LibraryParameters": "","Mode": "IPM_GENERAL"}    ],"MaxAlgorithmThreadCount": 1,"Name": "Settings","Timeout": 1000000},"Version": "3.0"}';

  List<String> scannedCodes = [];

  bool _isScanning = false;
  String _platformVersion = 'Unknown';
  //
  // Lifecycle
  //

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

  //
  // Actions
  //

  Future<void> _setup() async {
    try {
      _platformVersion = await _flutterWebTwain.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      var platformVersion = 'Failed to get platform version.';
    }
    _controller = _flutterWebTwain.getCameraController();
    await _dynamsoft
        .setLicense(
            "DLS2eyJoYW5kc2hha2VDb2RlIjoiMTAxMzcxNzgyLVRYbFhaV0pRY205cVgyUmljZyIsIm9yZ2FuaXphdGlvbklEIjoiMTAxMzcxNzgyIiwiY2hlY2tDb2RlIjo2NjY5NjI1MDF9")
        .catchError((e) {});
    await _dynamsoft.init();
    await _dynamsoft.setParameters(_dynamsoftParameters);
    await _controller!.init(
        facing: WebCameraFacing.next,
        streamImages: true,
        format: WebCameraOutputFormat.bytes,
        onImage: _onWebScannerImage);
    setState(() {});
  }

  Future<void> _onWebScannerImage(List<int>? imageData) async {
    if (_isScanning ||
        imageData == null ||
        _controller!.webviewVideoSize == null) return;
    _isScanning = true;
    final List<BarcodeResult> results = await _dynamsoft.decodeImageBuffer(
      Uint8List.fromList(imageData),
      _controller!.width,
      _controller!.height,
      _controller!.width * 4,
      ImagePixelFormat.IPF_ARGB_8888
          .index, // TODO: replace with Dynamsoft Capture Vision when it's out
    );
    // print("Barcodes found : ${results.map((res) => res.text).toList()}");
    _isScanning = false;
    widget.onScannedCodes(results.map((res) => res.text).toList());
  }

  //
  // UI
  //

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Dynamic Web TWAIN for Flutter'),
          ),
          body: Column(children: [
            Container(
              height: 100,
              child: Row(children: <Widget>[
                Text(
                  _platformVersion,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                )
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: _controller == null
                    ? const CircularProgressIndicator()
                    : HtmlElementView(viewType: _controller!.webviewId),
              ),
            ),
            Container(
              height: 100,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MaterialButton(
                        child: Text('Barcode Reader'),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () async {}),
                    MaterialButton(
                        child: Text('Barcode Scanner'),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () async {}),
                  ]),
            ),
          ])),
    );

    // @override
    // Widget build(BuildContext context) {
    //   return Scaffold(
    //       body: Center(
    //     child: _controller == null
    //         ? const CircularProgressIndicator()
    //         : HtmlElementView(viewType: _controller!.webviewId),
    //   ));
    // if (_controller!.webviewVideoSize == null) return Container();
    // return LayoutBuilder(builder: (context, constraints) {
    //   return ClipRect(
    //     child: SizedBox(
    //       width: constraints.maxWidth,
    //       height: constraints.maxHeight,
    //       child: FittedBox(
    //         fit: BoxFit.cover,
    //         child: SizedBox(
    //           width: _controller!.webviewVideoSize!.width,
    //           height: _controller!.webviewVideoSize!.height,
    //           child: HtmlElementView(viewType: _controller!.webviewId),
    //         ),
    //       ),
    //     ),
    //   );
    // });
  }
}
