    //
//  SwiftLiWebviewPlugin.swift
//  li_webview
//
//  Created by Cristian Gaviria on 21/09/19.
//

import Flutter
import UIKit
import WebKit
import Foundation


extension WKWebView {
    override open var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

public class WebViewController: NSObject, FlutterPlatformView, FlutterStreamHandler {

    let I_URL = "initialUrl"
    let HEADER = "header"
    let CHANNEL_NAME = "li_webview_%d"
    let CHANNEL = "li_webview_events_%d"

    fileprivate var LiWebView: WKWebView!
    fileprivate var viewId:Int64!;
    fileprivate var channel: FlutterMethodChannel!
    fileprivate var refLiView: UIRefreshControl?

    public init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger: FlutterBinaryMessenger) {
        super.init()

        if let initWebView =  self.initWebView(frame: frame, args) {
            FlutterEventChannel.init(name: String(format: CHANNEL, viewId),
                                    binaryMessenger: binaryMessenger).setStreamHandler(self)

            self.LiWebView = initWebView
            let channelName = String(format: CHANNEL_NAME, viewId)
            self.channel = FlutterMethodChannel(name: channelName, binaryMessenger: binaryMessenger)

            self.channel.setMethodCallHandler({
                [weak self]
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                if let this = self {
                    this.onMethodCall(call: call, result: result)
                }
            })
        }
    }

    private func initWebView (frame: CGRect, _ args: Any?) -> WKWebView? {
        if let params = args as? NSDictionary {

            let config = WKWebViewConfiguration()
            let LiWebView = WKWebView (frame: frame , configuration: config)
            LiWebView.scrollView.bounces = false

            if let url = params[I_URL] as? String,
            let iUrl = URL(string: url) {
                var request = URLRequest(url: iUrl)
                if let header = params[HEADER] as? NSDictionary {
                    for (key, value) in header {
                        if let val = value as? String,
                            let field = key as? String {
                            request.addValue(val, forHTTPHeaderField: field)
                        }
                    }
                }
                LiWebView.load(request)
            }
            return LiWebView
        }
        return nil
    }
    public func view() -> UIView {
        return LiWebView
    }

    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let method = FlutterMethodName(rawValue: call.method) {
            switch method {
            case .loadUrl:
                onLoadURL(call, result)
            case .evaluateJavascript:
                onEvaluateJavascript(call, result)
            }
        }
    }

    func onLoadURL(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let url = call.arguments as? String  {
            if !load(url: url) {
                result(FlutterError(code: "URL_FAILED", message: "Fail load url", details: "\(url)"))
            }else {
                result(FlutterMethodNotImplemented)
            }
        }
    }

    func load(url:String)-> Bool {
        if let urlRequest = URL(string: url) {
            LiWebView.load(URLRequest(url: urlRequest))
            return true
        }
        return false
    }

    func onEvaluateJavascript(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let jsString = call.arguments as? String  {
            LiWebView.evaluateJavaScript(jsString) { (evaluateResult, error) in
                if error != nil {
                    result(FlutterError(code: "failed_evaluatejs", message: "Failed evaluating JavaScript Code.", details: "Your [js code] was: \(jsString)"))

                }else if let res =  evaluateResult as? String {
                    result(res)
                }
            }
        }
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }

}
