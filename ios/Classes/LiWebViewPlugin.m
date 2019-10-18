#import "LiWebviewPlugin.h"
#import "FlutterWebView.h"

@implementation LiWebviewPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  WebViewFactory* webviewFactory =
      [[WebViewFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:webviewFactory withId:@"li_webview"];
}

@end
