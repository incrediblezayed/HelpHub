package com.h2.helphub

import io.flutter.app.FlutterApplication

import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService

class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingService.setPluginRegistrant(this)
    }
    override fun registerWith(registry: PluginRegistry) {
        FCMBackgroundPlugin.registerWith(registry)
    }

/*     private fun registerChannel(){
        val channel = NotificationChannel( "Help Hub", "Help Hub", NotificationManager.IMPORTANCE_HIGH)
        val manager = getSystemService(NotificationManager: class.java) as Notifica4tionManager;
        manager.createNotificationChannel(channel)
    } */
}