import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationControls extends StatelessWidget {
  final Future<WebViewController> _controllerFuture;

  const NavigationControls(this._controllerFuture, {key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _controllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return Row(
            children: <Widget>[
              _buildHistoryBackBtn(context, controller),
              _buildReloadBtn(controller),
              _buildHistoryForwardBtn(context, controller),
            ],
          );
        }

        return Container();
      },
    );
  }

  IconButton _buildReloadBtn(AsyncSnapshot<WebViewController> controller) {
    return IconButton(
      icon: Icon(Icons.refresh),
      onPressed: () {
        controller.data.reload();
      },
    );
  }

  FlatButton _buildHistoryForwardBtn(
      BuildContext context, AsyncSnapshot<WebViewController> controller) {
    return FlatButton(
      textColor: Colors.blue,
      child: Row(children: <Widget>[
        Icon(Icons.arrow_forward_ios_rounded),
      ]),
      onPressed: () async {
        if (await controller.data.canGoForward()) {
          controller.data.goForward();
        } else {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No forward history',
                style: TextStyle(fontSize: 10),
              ),
            ),
          );
        }
      },
    );
  }

  FlatButton _buildHistoryBackBtn(
      BuildContext context, AsyncSnapshot<WebViewController> controller) {
    return FlatButton(
      textColor: Colors.blue,
      child: Row(children: <Widget>[
        Icon(Icons.arrow_back_ios_rounded),
      ]),
      onPressed: () async {
        if (await controller.data.canGoBack()) {
          controller.data.goBack();
        } else {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No back history',
                style: TextStyle(fontSize: 10),
              ),
            ),
          );
        }
      },
    );
  }
}