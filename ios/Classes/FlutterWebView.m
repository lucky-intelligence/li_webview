#import "FlutterWebView.h"

@implementation WebViewFactory {
  NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
  WebViewController* webviewController =
      [[WebViewController alloc] initWithWithFrame:frame
                                       viewIdentifier:viewId
                                            arguments:args
                                      binaryMessenger:_messenger];
  return webviewController;
}

@end

@implementation WebViewController {
  WKWebView* _liwebView;
  int64_t _viewId;
  FlutterMethodChannel* _channel;
}

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if ([super init]) {
    _viewId = viewId;
    _liwebView = [[WKWebView alloc] initWithFrame:frame];
    _liwebView.scrollView.bounces = false;
    NSString* channelName = [NSString stringWithFormat:@"li_webview_%lld", viewId];
    _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
    __weak __typeof__(self) weakSelf = self;
    [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
      [weakSelf onMethodCall:call result:result];
    }];

  }
  return self;
}

- (UIView*)view {
  return _liwebView;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([[call method] isEqualToString:@"loadUrl"]) {
    [self onLoadUrl:call result:result];
  } else if ([[call method] isEqualToString:@"loadData"]) {
      [self onLoadData:call result:result];
  } else if ([[call method] isEqualToString:@"evaluateJavascript"]) {
    [self onEvaluateJavaScript:call result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}


- (void)onLoadUrl:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString* url = [call arguments];
  if (![self loadUrl:url]) {
    result([FlutterError errorWithCode:@"loadUrl_failed"
                               message:@"Failed parsing the URL"
                               details:[NSString stringWithFormat:@"URL was: '%@'", url]]);
  } else {
    result(nil);
  }
}

- (bool)loadUrl:(NSString*)url {
  NSURL* nsUrl = [NSURL URLWithString:url];
  if (!nsUrl) {
    return false;
  }
  NSURLRequest* req = [NSURLRequest requestWithURL:nsUrl];
  [_liwebView loadRequest:req];
  return true;
}


- (void)onLoadData:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* data = [call arguments];
    if (![self loadData:data]) {
        result([FlutterError errorWithCode:@"loadData_failed"
                                   message:@"Failed parsing the data"
                                   details:[NSString stringWithFormat:@"data was: '%@'", data]]);
    } else {
        result(nil);
    }
}

- (bool)loadData:(NSString*)data {
   
    [_liwebView loadHTMLString:data baseURL:nil];
    return true;
}
- (void)onEvaluateJavaScript:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString* jsString = [call arguments];
  if (!jsString) {
    result([FlutterError errorWithCode:@"evaluateJavaScript_failed"
      message:@"JavaScript String cannot be null"
      details:nil]);
    return;
  }
  [_liwebView evaluateJavaScript:jsString
    completionHandler:^(_Nullable id evaluateResult, NSError* _Nullable error) {
      if (error) {
        result([FlutterError
          errorWithCode:@"evaluateJavaScript_failed"
            message:@"Failed evaluating JavaScript"
            details:[NSString stringWithFormat:@"JavaScript string was: '%@'\n%@",
              jsString, error]]);
      } else {
        result([NSString stringWithFormat:@"%@", evaluateResult]);
      }
    }];
  }


@end
