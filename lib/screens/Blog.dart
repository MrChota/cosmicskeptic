import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'navigation_controls.dart';

class Blog extends StatefulWidget {
  Blog({Key key}) : super(key: key);

@override
_BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  final globalKey = GlobalKey<ScaffoldState>();

  String _title = 'Blog';

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(_title),
        elevation: 0.0,
        backgroundColor: Colors.black,
        actions: <Widget>[
          NavigationControls(_controller.future),
        ],
      ),
      body: _buildWebView(),
      floatingActionButton: _buildShowUrlBtn(),
    );
  }

  Widget _buildWebView() {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: 'https://cosmicskeptic.com/',
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

  Widget _buildShowUrlBtn() {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () async {
              String url = await controller.data.currentUrl();

              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Current url is: $url',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              );
            },
            child: Icon(Icons.link),
          );
        }

        return Container();
      },
    );
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
         // _title = newTitle;
        });
      },
    );
  }
}