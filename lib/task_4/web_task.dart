import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class FourthTask extends StatefulWidget {
  const FourthTask({super.key});

  @override
  State<FourthTask> createState() => _FourthTaskState();
}

class _FourthTaskState extends State<FourthTask> {
  final TextEditingController _textEditingController = TextEditingController();
  late WebViewController _controller;
  bool isLoading = true;
  String currentUrl = '';
  bool canGoBack = false;
  bool canGoForward = false;

  @override
  void initState() {
    super.initState();
    WebView.platform = SurfaceAndroidWebView();
    _textEditingController.addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Flutter Browser'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: canGoBack
                    ? () {
                        _goBack();
                      }
                    : null,
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                ),
              ),
              IconButton(
                onPressed: canGoForward
                    ? () {
                        _goForward();
                      }
                    : null,
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
              ),
              !isLoading
                  ? IconButton(
                      onPressed: () {
                        _refresh();
                      },
                      icon: const Icon(
                        Icons.refresh,
                        size: 28,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        _stopLoading();
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 28,
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                child: SizedBox(
                  height: 30,
                  width:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.width * 0.62
                          : MediaQuery.of(context).size.width * 0.78,
                  child: TextFormField(
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (value) {
                      _loadUrl(value);
                    },
                    textAlign: TextAlign.center,
                    controller: _textEditingController..text = currentUrl,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      hoverColor: Colors.transparent,
                      fillColor: Colors.grey[300],
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 1),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber, width: 10),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: WebView(
              initialUrl: 'https://flutter.dev',
              onWebViewCreated: (controller) async {
                _controller = controller;
                await _controller.currentUrl().then((value) {
                  currentUrl = value!;
                });
              },
              navigationDelegate: (navigation) {
                return NavigationDecision.navigate;
              },
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (url) {
                setState(() {
                  isLoading = false;
                });
              },
              onPageStarted: (url) {
                isLoading = true;
                _controller.currentUrl().then((value) async {
                  await _controller.canGoBack()
                      ? canGoBack = true
                      : canGoBack = false;
                  await _controller.canGoForward()
                      ? canGoForward = true
                      : canGoForward = false;
                  setState(() {
                    currentUrl = value!;
                  });
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _goBack() async {
    await _controller.goBack();
  }

  void _goForward() async {
    await _controller.goForward();
  }

  void _refresh() async {
    await _controller.reload();
  }

  void _stopLoading() async {
    await _controller.loadUrl("");
  }

  void _loadUrl(String link) async {
    await _controller.loadUrl('https://$link');
  }
}
