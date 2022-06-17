import 'package:flutter/material.dart';
import 'package:weather_modification_app/views/web_app/index.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '人影',

      theme: ThemeData(
        primarySwatch: Colors.blue
      ),

      routes: <String, WidgetBuilder> {
        '/webapp': (BuildContext context) => const WebApp()
      },
      home: const WebApp(),
    );
  }
}