package com.luckyintelligence.li_webview

import android.content.Context
import android.view.View
import android.webkit.WebView
import android.webkit.WebViewClient
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
            else -> result.notImplemented()
        }
    }

    private fun getWebView(registrar : Registrar) : WebView {
        val webView : WebView = WebView(registrar.context())
        webView.setWebViewClient(WebViewClient())
        webView.getSettings().javaScriptEnabled = true
        return webView
    }

}