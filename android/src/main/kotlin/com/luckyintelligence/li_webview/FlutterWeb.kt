package com.luckyintelligence.li_webview

import android.content.Context
import android.view.View
import android.webkit.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.platform.PlatformView

public class FlutterWeb : PlatformView, MethodCallHandler {
    public lateinit var context : Context
    public lateinit var registrar : Registrar
    public lateinit var webView : WebView
    public lateinit var url : String
    public lateinit var channel : MethodChannel

    constructor(context : Context, registrar : Registrar, id : Int) {
        this.context = context
        this.registrar = registrar

        webView = getWebView(registrar)
        channel = MethodChannel(registrar.messenger(), "li_webview_$id")
        channel.setMethodCallHandler(this)
    }

    override fun getView(): View {
        return webView
    }

    override fun dispose() {

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method) {
            "loadUrl" -> {
                val url : String = call.arguments.toString()
                webView.loadUrl(url)
            }
            "evaluateJavascript" -> {
                var js : String = call.arguments.toString()
                println("Execute: "+js);
                webView.evaluateJavascript(js, { e ->
                    println(e)
                    result.success(e);
                })
            }
            "clearDiskCache" -> {
                webView.clearCache(true)
            }
            "clearRamCache" -> {
                webView.clearCache(false)
            }
            else -> result.notImplemented()
        }
    }

    private fun getWebView(registrar : Registrar) : WebView {
        val webView : WebView = WebView(registrar.context())
        webView.webChromeClient = object: WebChromeClient(){
            override fun onProgressChanged(view: WebView, newProgress: Int){
                if(newProgress == 100){
                    channel.invokeMethod("webLoaded", null)
                }
            }

            override fun onJsAlert(view: WebView?, url: String?, message: String?, result: JsResult?): Boolean {
                channel.invokeMethod("onAlert", message)
                return super.onJsAlert(view, url, message, result)
            }

            override fun onConsoleMessage(consoleMessage: ConsoleMessage?): Boolean {
                if (consoleMessage != null) {
                    channel.invokeMethod("onMessage", consoleMessage.message())
                };
                return super.onConsoleMessage(consoleMessage)
            }
        }
        webView.getSettings().javaScriptEnabled = true
        return webView
    }

}