import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef void WebViewCreatedCallback(WebController controller);
typedef void WebViewLoadedCallback(WebController controller);
typedef void WebViewAlertCallback(WebController controller, String message);
typedef void WebViewConsoleCallback(WebController controller, String message);

class LiWebView extends StatefulWidget {
  final WebViewCreatedCallback onWebCreated;
  final WebViewLoadedCallback onWebLoaded;
  final WebViewAlertCallback onWebAlert;
  final WebViewConsoleCallback onWebConsole;

  const LiWebView({
    Key key,
    @required this.onWebCreated,
    @required this.onWebLoaded,
    this.onWebAlert,
    this.onWebConsole,
    this.initialUrl,
    this.header
  });

  final String initialUrl;
  final Map header;

  @override
  State<StatefulWidget> createState() => _LiWebView();
}

class _LiWebView extends State<LiWebView> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: "li_webview",
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec()
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: 'li_webview',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: _InitialParams.fromWidget(widget).toMap(),
      );
    }
    return Text("Not supported device");
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> onPlatformViewCreated(id) async {
    if (widget.onWebCreated == null) {
      return;
    }

    widget.onWebCreated(new WebController.init(id, widget));
  }
}

class WebController {
  MethodChannel _channel;
  LiWebView wb;

  WebController.init(int id, LiWebView wb) {
    this._channel =  new MethodChannel('li_webview_$id');
    this._channel.setMethodCallHandler(_onMethodCall);
    this.wb = wb;
  }

  Future<bool> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'webLoaded': {
        this.wb.onWebLoaded(this);
        return null;
      }
      case 'onAlert': {
        this.wb.onWebAlert(this, call.arguments.toString());
        return null;
      }
      case 'onMessage': {
        this.wb.onWebAlert(this, call.arguments.toString());
        return null;
      }
    }
    throw MissingPluginException('${call.method} was invoked but has no handler');
  }

  Future<void> loadUrl(String url) async {
    assert(url != null);
    return _channel.invokeMethod('loadUrl', url);
  }

  Future<dynamic> evaluateJavascript(String javascriptString) async {
    final result = await _channel.invokeMethod('evaluateJavascript', javascriptString);
    return result;
  }

  Future<void> clearDiskCache() async {
    return _channel.invokeMethod('clearDiskCache');
  }

  Future<void> clearRamCache() async {
    return _channel.invokeMethod('clearRamCache');
  }

}

class _InitialParams {
  _InitialParams({
      this.initialUrl,
      this.header
  });

  static _InitialParams fromWidget(LiWebView widget) {
    return _InitialParams(
        initialUrl: widget.initialUrl,
        header: widget.header
    );
  }

  final String initialUrl;
  final Map header;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'initialUrl': initialUrl,
      'header': header
    };
  }

}
