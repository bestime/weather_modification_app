import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';


/// 与webview通信工具
class WebRequestMessage {
  String name;
  String message;

  WebRequestMessage({
    required this.name,
    required this.message
});
}

class JsBridge {
  static WebRequestMessage parseMessage (String message) {
    dynamic res = jsonDecode(message);
    return WebRequestMessage(
      name: '${res['name']}',
      message: res['message'],
    );
  }

  static send (WebViewController controller, WebRequestMessage msg) {
    Map<String, dynamic> data = {
      'name': msg.name,
      'message': msg.message
    };

    String response = jsonEncode(data);
    

    String jsStr = "window.RyListenAppEvent('${response}')";
    print("推送到web => $jsStr");
    controller.runJavascript(jsStr);
  }

  /// 回复web消息
  static reply (WebViewController controller, WebRequestMessage data) {

    WebRequestMessage msg = WebRequestMessage(
        name: data.name,
      message: data.message
    );



    send(controller, msg);
  }

}

