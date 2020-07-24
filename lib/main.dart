import 'package:flutter/material.dart';
import './screens/hospital_screen.dart';
import './screens/hospital_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        accentColorBrightness: Brightness.dark,
      ),
      home: HospitalScreen(),
      routes: {
        HospitalDetailScreen.routeName: (ctx) => HospitalDetailScreen(),
      },
    );
  }
}
