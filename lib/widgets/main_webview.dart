import 'dart:io';

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
  bool isLoading = false;

  late PullToRefreshController _pullToRefreshController;
  double progress = 0;

  final InAppWebViewGroupOptions _options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      useOnLoadResource: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  @override
  void initState() {
    super.initState();

    _pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: const Color(0xFF34495E),
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          _webViewController.reload();
        } else if (Platform.isIOS) {
          _webViewController.loadUrl(
              urlRequest: URLRequest(url: await _webViewController.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

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
          child: Column(
        children: [
          isLoading
              ? LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFFF1C40F),
                  color: const Color(0xFF34495E),
                  minHeight: 5,
                )
              : const SizedBox(),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse('https://dewikreatif.com/'),
              ),
              pullToRefreshController: _pullToRefreshController,
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
                _pullToRefreshController.endRefreshing();
                setState(() {
                  isLoading = false;
                });
              },
              onLoadError: (_, __, ___, ____) =>
                  _pullToRefreshController.endRefreshing(),
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  _pullToRefreshController.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                  isLoading = true;
                });
              },
              onWebViewCreated: (controller) => _webViewController = controller,
              initialOptions: _options,
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
                  setState(() {
                    isLoading = true;
                  });
                  return NavigationActionPolicy.ALLOW;
                }
              },
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
            ),
          ),
        ],
      )),
    );
  }
}
