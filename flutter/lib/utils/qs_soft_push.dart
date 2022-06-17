import 'package:jpush_flutter/jpush_flutter.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:weather_modification_app/utils/event_bus.dart';
import 'package:weather_modification_app/utils/global.dart';



JPush _init () {
  final JPush oPush = JPush();
  String? platformVersion;

  try {
    oPush.addEventHandler(
      onReceiveNotification: (Map<String, dynamic> message) async {
        print("收到推送 => ${message['alert']}");
        ryBus.emit('JPushMessageOnReceiveNotification', message);
      },
      onOpenNotification: (Map<String, dynamic> message) async {
        print("打开推送 => $message");
      },
      onReceiveMessage: (Map<String, dynamic> message) async {
        print("收到消息 => ${message['alert']} ");

      },
      onReceiveNotificationAuthorization: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
      }
    );
  } on PlatformException {
    print('极光推送失败了 => $platformVersion');
  }

  oPush.setup(
    appKey: "1a4141e06e93be7770196564", //你自己应用的 AppKey
    channel: "developer-default",
    production: false,
    debug: false,
  );

  // oPush.applyPushAuthority(const NotificationSettingsIOS(sound: true, alert: true, badge: true));
  return oPush;
 }

JPush qsSoftPush = _init();