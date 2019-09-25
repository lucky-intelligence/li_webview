import 'package:flutter/material.dart';
import 'package:li_webview/li_webview.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  WebController webController;

  void onWebCreated(webController) {
    this.webController = webController;
    this.webController.loadUrl("http://www.google.com");
  }

  @override Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        color: Colors.red,
        child: LiWebView(
          onWebCreated: onWebCreated,
        ),
        height: double.infinity,
      ),
      color: Colors.black,
    );
  }
}