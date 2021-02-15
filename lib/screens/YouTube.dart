import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'navigation_controls.dart';

class YouTube extends StatefulWidget {
  YouTube({Key key}) : super(key: key);

  @override
  _YouTubeState createState() => _YouTubeState();
}

class _YouTubeState extends State<YouTube> {
  final globalKey = GlobalKey<ScaffoldState>();

  String _title = 'CosmicSkeptic';

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(_title),
        elevation: 0.0,
        backgroundColor: Colors.black12,
        actions: <Widget>[
          NavigationControls(_controller.future),
        ],
      ),
      body: _buildWebView(),
    );
  }

  Widget _buildWebView() {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: 'https://m.youtube.com/channel/UC7kIy8fZavEni8Gzl8NLjOQ',
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
      navigationDelegate: (request) {
        return _buildNavigationDecision(request);
      },
      javascriptChannels: <JavascriptChannel>[
        _createTopBarJsChannel(),
      ].toSet(),
      onPageFinished: (url) {
        _showPageTitle();
      },
    );
  }

  NavigationDecision _buildNavigationDecision(NavigationRequest request) {
    if (request.url.contains('my-account')) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'You do not have rights to access My Account page',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );

      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  void _showPageTitle() {
    _controller.future.then((webViewController) {
      webViewController
          .evaluateJavascript('TopBarJsChannel.postMessage(document.title);');
    });
  }

  JavascriptChannel _createTopBarJsChannel() {
    return JavascriptChannel(
      name: 'TopBarJsChannel',
      onMessageReceived: (JavascriptMessage message) {
        String newTitle = message.message;

        if (newTitle.contains('-')) {
          newTitle = newTitle.substring(0, newTitle.indexOf('-')).trim();
        }

        setState(() {
          //_title = newTitle;
        });
      },
    );
  }
}