import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import './home.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: new Home(),
      title: new Text(
        'Welcome to Voice',
        style: new TextStyle(fontFamily: "NunitoSans",fontWeight: FontWeight.bold, fontSize: 34.0),
      ),
      // image: new Image.network(
      //     'https://flutter.io/images/catalog-widget-placeholder.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(fontFamily: "NunitoSans", fontSize: 22),
      photoSize: 100.0,
      onClick: () => print("Flutter Egypt"),
      loaderColor: Colors.blue,
    );
  }
}
