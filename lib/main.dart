import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pertama/src/injector/injector.dart';
import 'package:pertama/src/ui/app.dart';
void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await setupLocator();
    runApp(App());
  } catch (error, stacktrace) {
    print('$error & $stacktrace');
  }
}