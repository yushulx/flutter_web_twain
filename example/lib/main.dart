import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_web_twain/flutter_web_twain.dart';

import 'scanner.dart';

void main() {
  runApp(ScannerWidget(onScannedCodes: (List<String> newScannedCodes) {}));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<String>> scansResult = [];

  void _onScannedCodes(List<String> newScannedCodes) {
    scansResult.add(newScannedCodes);
    setState(() {});
  }

  void _resetCodes() {
    scansResult.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<List<String>> emptyScans =
        scansResult.where((element) => element.isEmpty).toList();
    final List<List<String>> notEmptyScans =
        scansResult.where((element) => element.isNotEmpty).toList();
    return Scaffold(
      appBar: AppBar(title: const Text("Dynamsoft Trucks'nB Web")),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 400,
              child: Center(
                child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ScannerWidget(onScannedCodes: _onScannedCodes)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text("Scan counts : ${scansResult.length}"),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text("Empty Scan counts : ${emptyScans.length}"),
            ),
            Expanded(
                child: ListView.separated(
              itemCount: notEmptyScans.length,
              itemBuilder: (context, index) {
                return Column(
                  children: notEmptyScans[index]
                      .map((code) => Text("`$code`"))
                      .toList(),
                );
              },
              separatorBuilder: (_, __) {
                return Container(
                  color: Colors.grey,
                  height: 1,
                  width: double.infinity,
                );
              },
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetCodes,
        child: const Icon(Icons.clear_all),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
