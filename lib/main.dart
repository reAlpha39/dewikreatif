import 'package:dewikreatif/widgets/main_webview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'dewikreatif',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainWebView());
  }
}




