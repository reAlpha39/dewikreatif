import 'package:dewikreatif/widgets/splash_screen_loading.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MainWebView extends StatefulWidget {
  const MainWebView({super.key});

  @override
  State<MainWebView> createState() => _MainWebViewState();
}

class _MainWebViewState extends State<MainWebView> {
  late WebViewController _webViewController;

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
            onPageStarted: (_) => showGeneralDialog(
                context: context,
                pageBuilder: (_, __, ___) => const SplashScreenLoading()),
            onPageFinished: (_) => Navigator.pop(context),
            onWebViewCreated: (controller) => _webViewController = controller,
          ),
        ),
      ),
    );
  }
}
