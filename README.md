# flutter_web_twain

The Flutter plugin is a wrapper for Dynamsoft's [Web TWAIN SDK](https://www.dynamsoft.com/web-twain/overview/). It allows you to build web document scanning applications with Flutter.

## Getting a License Key for Dynamic Web TWAIN
[![](https://img.shields.io/badge/Get-30--day%20FREE%20Trial-blue)](https://www.dynamsoft.com/customer/license/trialLicense/?product=dwt)

## Installation
1. Add `flutter_web_twain` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).
2. In the root of your project, download the Dynamic Web TWAIN npm package:

    ```bash
    npm install dwt
    ```
3. Include the following line in your `index.html` file:

    ```html
    <script src="node_modules/dwt/dist/dynamsoft.webtwain.min.js"></script>
    ```


## Usage
- Initialize the Flutter Web TWAIN SDK:

     ```dart
    final FlutterWebTwain _flutterWebTwain = FlutterWebTwain();
    WebTwainController _controller = await _flutterWebTwain.createWebTwainController();
    await _controller!.init('node_modules/dwt/dist/',
            'LICENSE-KEY');
    ```

- Embed the image container into your widget tree:

    ```dart
    Expanded(
        child: _controller == null
            ? const CircularProgressIndicator()
            : HtmlElementView(viewType: _controller!.webviewId),
    ),
    ```
- Acquire documents from a document scanner:

    ```dart
    await _controller!.scan(
        '{"IfShowUI": false, "PixelType": ${_pixelFormat!.index}}');
    ```

- Load images from the local file system:

    ```dart
    await _controller!.load();
    ```

- Save single or multiple images as PDF, TIFF or JPEG:

    ```dart
    await _controller!.download(FileFormat.PDF.index, 'filename');
    ```

## Try the Example

```bash
cd example
flutter run -d chrome
```

![Flutter web document scanning SDK](https://www.dynamsoft.com/codepool/img/2022/11/flutter-web-document-scanner.png)

