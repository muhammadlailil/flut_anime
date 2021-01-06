import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pertama/src/constant/colors.dart';
import 'package:pertama/src/injector/injector.dart';
import 'package:pertama/src/storage/sharedpreferences/shared_preferences_manager.dart';
import 'package:pertama/src/ui/home/home_screen.dart';

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreen(),
    );
  }

}
