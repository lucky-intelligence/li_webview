import 'dart:async';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef void WebViewCreatedCallback(WebController controller);

class LiWebView extends StatefulWidget {
  final WebViewCreatedCallback onWebCreated;

  const LiWebView({
    Key key,
    @required this.onWebCreated,
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

    widget.onWebCreated(new WebController.init(id));
  }
}

class WebController {
  MethodChannel _channel;

  WebController.init(int id) {
    _channel =  new MethodChannel('li_webview_$id');
  }

  Future<void> loadUrl(String url) async {
    assert(url != null);
    return _channel.invokeMethod('loadUrl', url);
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
