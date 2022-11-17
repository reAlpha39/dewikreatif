import 'package:dewikreatif/widgets/splash_screen_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class MainWebView extends StatefulWidget {
  const MainWebView({super.key});

  @override
  State<MainWebView> createState() => _MainWebViewState();
}

class _MainWebViewState extends State<MainWebView> {
  late InAppWebViewController _webViewController;
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
      child: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse('https://dewikreatif.com/'),
          ),
          onLoadStart: (_, __) {
            if (firstLoad) {
              showGeneralDialog(
                  barrierDismissible: false,
                  context: context,
                  pageBuilder: (_, __, ___) => const SplashScreenLoading());
            }
          },
          onLoadStop: (_, __) {
            if (firstLoad) {
              firstLoad = false;
              Navigator.pop(context);
            }
          },
          onWebViewCreated: (controller) => _webViewController = controller,
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              useShouldOverrideUrlLoading: true,
              useOnLoadResource: true,
            ),
          ),
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            Uri url = navigationAction.request.url!;
            if (![
              'http',
              'https',
              'file',
              'chrome',
              'data',
              'javascript',
              'about'
            ].contains(url.scheme)) {
              await launchUrl(url);
              return NavigationActionPolicy.CANCEL;
            } else {
              return NavigationActionPolicy.ALLOW;
            }
          },
        ),
      ),
    );
  }
}
