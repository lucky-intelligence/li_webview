//
//  SwiftLiWebviewPlugin.swift
//  li_webview
//
//  Created by Cristian Gaviria on 21/09/19.
//

#import "LiWebviewPlugin.h"
#import <li_webview/li_webview-Swift.h>

@implementation LiWebviewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

    [registrar registerViewFactory: [[WebViewFactory alloc] initWithMessenger:[registrar messenger]] withId:@"li_webview"];
}
@end
