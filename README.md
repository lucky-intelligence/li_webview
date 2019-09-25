# li_webview

Yet another web view plugin

## Instructions

Import li_web_view

```dart
import 'package:li_webview/li_webview.dart';
```

Add it as a container's child and define a function to handle the callback of the web view creation

### Example:

```dart
void onWebCreated(webController) {
    this.webController = webController;
    this.webController.loadUrl("http://www.google.com");
}

@override Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
            child: LiWebView(
                onWebCreated: onWebCreated,
            ),
            height: double.infinity,
        ),
    );
}
```
The web view is automatically going to adapt the parent properties in order to have a more natural control of it

And that's it