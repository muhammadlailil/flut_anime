import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
void LoadingDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.black.withOpacity(0.7),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    },
  );
}