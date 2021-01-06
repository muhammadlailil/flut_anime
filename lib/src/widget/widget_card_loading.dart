import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetCardLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          child: Center(
            child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
