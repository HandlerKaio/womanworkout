package com.pas.women.workout.fatburn


import android.os.Bundle
import android.view.LayoutInflater
import com.facebook.FacebookSdk
import com.facebook.FacebookSdk.setAutoLogAppEventsEnabled
import com.facebook.LoggingBehavior
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import java.util.*


class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FacebookSdk.isInitialized();
        setAutoLogAppEventsEnabled(true);
        FacebookSdk.setIsDebugEnabled(true);
        FacebookSdk.addLoggingBehavior(LoggingBehavior.APP_EVENTS);



    }


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        flutterEngine.plugins.add(GoogleMobileAdsPlugin())
        super.configureFlutterEngine(flutterEngine)

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "NativeCompleted",
            NativeAdFactoryCompleted(LayoutInflater.from(this))
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "Listitle",
            NativeAdFactoryExample(LayoutInflater.from(this))
        )
    }


}