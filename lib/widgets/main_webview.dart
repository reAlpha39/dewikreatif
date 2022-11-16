import 'package:dewikreatif/widgets/splash_screen_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MainWebView extends StatefulWidget {
  const MainWebView({super.key});

  @override
  State<MainWebView> createState() => _MainWebViewState();
}

class _MainWebViewState extends State<MainWebView> {
  late WebViewController _webViewController;
  bool firstLoad = true;

  Future<bool> _customGoBack() async {
    if (await _webViewController.canGoBack()) {
      _webViewController.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _customGoBack(),
      child: Scaffold(
        body: SafeArea(
          child: WebView(
            initialUrl: 'https://dewikreatif.com/',
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (_) {
              if (firstLoad) {
                showGeneralDialog(
                    barrierDismissible: false,
                    context: context,
                    pageBuilder: (_, __, ___) => const SplashScreenLoading());
              }
            },
            onPageFinished: (_) {
              if (firstLoad) {
                firstLoad = false;
                Navigator.pop(context);
              }
            },
            onWebViewCreated: (controller) => _webViewController = controller,
          ),
        ),
      ),
    );
  }
}
