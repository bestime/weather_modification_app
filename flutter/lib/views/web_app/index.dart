import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_modification_app/widgets/RyWebView/index.dart';

const String defaultUrl = 'http://192.168.43.11:100/git/cqry/weather_modification_app/h5/index.html?t=56';

class WebApp extends StatefulWidget {
  const WebApp({Key? key}) : super(key: key);

  @override
  State<WebApp> createState() => _WebApp();
}

class _WebApp extends State<WebApp> {
  String appUrl = defaultUrl;

  final TextEditingController _controller =
      TextEditingController(text: defaultUrl);

  void jumpToWebView() {
    setState(() {
      appUrl = _controller.value.text;
    });
    print('跳转：' + appUrl);
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                  ),
                ),
                MaterialButton(
                    onPressed: jumpToWebView,
                    color: Colors.blue,
                    child: const Text('确定')),
              ],
            ),
            Expanded(
                child: RyWebView(
              url: appUrl,
            )),
          ],
        ),
      ),
    );
  }
}
