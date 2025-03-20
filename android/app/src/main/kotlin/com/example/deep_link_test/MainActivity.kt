package com.example.deep_link_test

import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "sendDataToApp") {
                    val packageName = call.argument<String>("packageName")
                    val data = call.argument<String>("data")

                    if (packageName != null && data != null) {
                        val success = launchApp(packageName, data)
                        if (success) {
                            result.success("App launched successfully")
                        } else {
                            result.error("APP_NOT_FOUND", "App not installed", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENTS", "Missing data or packageName", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun launchApp(packageName: String, data: String): Boolean {
        val packageManager = packageManager
        return try {
            // Check if the app is installed
            packageManager.getPackageInfo(packageName, PackageManager.GET_ACTIVITIES)

            // Launch the app with the given data
            val intent = Intent(Intent.ACTION_SEND)
            intent.setPackage(packageName)
            intent.putExtra(Intent.EXTRA_TEXT, data)
            intent.type = "text/plain"
            startActivity(intent)

            Log.d("DeepLinkTest", "Launching app: $packageName with data: $data")
            true
        } catch (e: PackageManager.NameNotFoundException) {
            Log.e("DeepLinkTest", "App not found: $packageName")
            false
        } catch (e: Exception) {
            Log.e("DeepLinkTest", "Error launching app: ${e.message}")
            false
        }
    }
}