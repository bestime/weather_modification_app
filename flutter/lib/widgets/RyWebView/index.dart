import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_modification_app/utils/global.dart';
import 'package:weather_modification_app/utils/js_bridge.dart';
import 'package:weather_modification_app/utils/qs_soft_push.dart';
import 'package:webview_flutter/webview_flutter.dart';

emitH5(String id, String message) {}

class RyWebView extends StatefulWidget {
  final String url;

  const RyWebView({required this.url, Key? key}) : super(key: key);

  @override
  State<RyWebView> createState() => _RyWebView();
}

class _RyWebView extends State<RyWebView> {
  WebViewController? _controller;


  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'RyH5AppChannel',
        onMessageReceived: (JavascriptMessage message) {
          WebRequestMessage result = JsBridge.parseMessage(message.message);
          JsBridge.reply(_controller!, result);

          // showDialog(
          //     context: context,
          //     builder: (context) {
          //
          //       return AlertDialog(
          //         title: Text('收到web消息'),
          //         content: Text(message.message),
          //       );
          //     });
        });
  }


  /// 监听极光推送消息
  listenQsPushMessage () {
    print('打开监听');
    ryBus.on('JPushMessageOnReceiveNotification', (Map data, Map busItem) {
      print("webview收到消息 ${data}");
      if(_controller != null) {
        WebRequestMessage msg = WebRequestMessage(
            name: 'JPush',
          message: jsonEncode({
            "title": data['title'],
            "alert": data['alert']
          })
        );
        JsBridge.send(_controller!, msg);
      }
    });
  }

  sendRegistrationId (String id) {
    WebRequestMessage msg = WebRequestMessage(
        name: 'jPush',
        message: '您的极光推送ID为：$id'
    );
    JsBridge.send(_controller!, msg);
  }

  @override
  void initState() {
    super.initState();
    listenQsPushMessage();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("最新地址：" + widget.url);
    // _controller?.loadUrl(widget.url);
    return WebView(
        backgroundColor: const Color(0x00000000),
        javascriptChannels: <JavascriptChannel>{
          _toasterJavascriptChannel(context)
        },
        onWebResourceError: (WebResourceError error) {
          print(
              "网页报错 ${error.errorCode} => ${error.description} => ${error.domain}");
        },
        onPageFinished: (String d) {
          qsSoftPush.getRegistrationID().then((String id) {
            print('极光推送的设备ID：$id');
            sendRegistrationId(id);
          });
        },
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController v) {
          _controller = v;
          _controller?.loadUrl(widget.url);

        });
  }
}
