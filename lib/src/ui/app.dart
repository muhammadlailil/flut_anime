import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pertama/src/injector/injector.dart';
import 'package:pertama/src/storage/sharedpreferences/shared_preferences_manager.dart';
import 'package:pertama/src/ui/activity/main_activity.dart';

class App extends StatelessWidget {
  final SharedPreferencesManager _sharedPreferencesManager =
      locator<SharedPreferencesManager>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark));

    bool _isAlreadyLoggedIn = _sharedPreferencesManager
            .isKeyExists(SharedPreferencesManager.keyIsLogin)
        ? _sharedPreferencesManager.getBool(SharedPreferencesManager.keyIsLogin)
        : false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF9F9F9),
      ),
      home: _isAlreadyLoggedIn ? MainActivity() : MainActivity(),
//      onGenerateRoute: onGenerateRoute,
    );
  }
}
