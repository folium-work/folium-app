import 'views/Home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appName = 'Folium';

    return MaterialApp(
      title: appName,
      theme: ThemeData(

        brightness: Brightness.dark,
        primaryColor: const Color(0xFFfafafa),
        primaryColorDark: const Color(0xFF4f4f4f),
        accentColor: const Color(0xFF24bfa4),
        backgroundColor: const Color(0xFF243645),

        fontFamily: 'Montserrat',

        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: new Home(
        title: appName,
      ),
    );
  }
}
