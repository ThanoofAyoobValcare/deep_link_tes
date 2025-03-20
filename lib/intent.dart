import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

const platform = MethodChannel('com.example.channel');

Future<void> launchSecondApp(String token, String pageName,
    BuildContext context, String packageName) async {
  try {
    if (Platform.isAndroid) {
      // Check if the app is installed and open it
      // final packageName =
      //     "com.geojit.myg"; // Replace with the actual package name
      // Invoke the method 'sendDataToApp' on the native side and pass data and target app package name
      final data = jsonEncode({
        "token": token,
        "userId": "",
        "pageName": pageName,
        "misc1": "",
        "misc2": "",
      });

      await platform.invokeMethod('sendDataToApp', {
        'data': data,
        'packageName': packageName // Target app package name (e.g., WhatsApp)
      });
    } else {
      // Fallback for non-Android platforms
      await launchUrl(
        Uri.parse("https://example.page.link/demo"),
        mode: LaunchMode.externalApplication,
      );
    }
  } on PlatformException catch (e) {
    print("Error: ${e.message}");
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(e.toString())));
  }
}