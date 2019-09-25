package com.luckyintelligence.li_webview

import android.content.Context
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

public class WebFactory : PlatformViewFactory {

    private lateinit var mPluginRegistrar : PluginRegistry.Registrar

    constructor(registrar : PluginRegistry.Registrar)
            : super(StandardMessageCodec.INSTANCE) {
        this.mPluginRegistrar = registrar
    }

    override fun create(context: Context, i: Int, o: Any?): PlatformView {
        return FlutterWeb(context, mPluginRegistrar, i);
    }
}