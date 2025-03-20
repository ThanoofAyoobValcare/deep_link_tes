import 'dart:io';

import 'package:deep_link_test/intent.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TextFieldPage(),
    );
  }
}

class TextFieldPage extends StatefulWidget {
  @override
  _TextFieldPageState createState() => _TextFieldPageState();
}

class _TextFieldPageState extends State<TextFieldPage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  Future<void> _copyText() async {
    String token = _controller1.text;
    String userId = _controller3.text;
    String pageName = _controller2.text;
    String url =
        'com.geojit.myg://open/?token=$token&userId=$userId&pageName=$pageName';
    try {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint(e.toString());
    }

    //     try {
    //   const urlScheme = 'com.geojit.myg';
    //   final uri = Uri(scheme: urlScheme, queryParameters: {
    //     "token": _controller1.text,
    //     "user": _controller3.text,
    //     "pagename": _controller2.text,
    //   });

    //   // Try launching the first URL
    //   bool launched = await launchUrl(uri,mode: LaunchMode.externalApplication);

    //   // If it doesn't work, fall back to the app store URL
    //   if (!launched) {
    //     const appStoreUrl = 'https://apps.apple.com/in/';
    //     await launchUrl(Uri.parse(appStoreUrl));
    //   }
    // } catch (e) {
    //   debugPrint(e.toString());
    // }
  }

  Future<void> _ssslaunchUrl(
    Uri uri,
  ) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Copy-Paste TextFields")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller1,
              decoration: InputDecoration(
                labelText: "Enter token",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _controller2,
              decoration: InputDecoration(
                labelText: "Enter pagename",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(height: 16),
            TextField(
              controller: _controller3,
              decoration: InputDecoration(
                labelText: "Enter userid",
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: _copyText,
              child: Text("Launch apps using custom  scheme"),
            ),
            Platform.isAndroid
                ? ElevatedButton(
                    onPressed: () {
                      launchSecondApp(
                          _controller1.text, _controller2.text, context);
                    },
                    child: Text("Launch app using intent in Android"))
                : ElevatedButton(
                    onPressed: () async {
                      final uri = Uri(
                        scheme: "com.geojit.myg",
                        queryParameters: {
                          'token': _controller1.text,
                          'pageName': _controller2.text,
                          'userId': _controller3.text,
                          'misc1': "",
                          'misc2': "",
                        },
                      );

                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    },
                    child: Text("iOS scheme"),
                  ),
          ],
        ),
      ),
    );
  }
}
