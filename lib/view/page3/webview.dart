import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../widget/appBar.dart';

class WebView extends StatefulWidget {
  const WebView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {

  WebViewController? _webViewController;

  @override
  void initState() {
    String url;
    if(widget.title == "개인정보처리방침") {
      url = 'https://steep-porch-f6c.notion.site/a7e5734f8a5e4fe8baa3554678097448';
    } else if(widget.title == "이용약관") {
      url = 'https://steep-porch-f6c.notion.site/cb2fb761fe514acd834431c6d2cff24c';
    } else {
      url = "";
    }
    _webViewController = WebViewController()
      ..loadRequest(Uri.parse(url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          appbar(context, widget.title),
          Expanded(child: WebViewWidget(controller: _webViewController!)),
        ],
      ),
    );
  }
}
