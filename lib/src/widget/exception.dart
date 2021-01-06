import 'package:flutter/material.dart';
import 'package:pertama/src/constant/colors.dart';
import 'package:pertama/src/constant/fonts.dart';

// ignore: non_constant_identifier_names
void ExceptionDialog(BuildContext context,String error) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return SingleChildScrollView(
          child: Container(
            padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Wrap(
              children: <Widget>[
                Text(
                  error,
                  style: TextStyle(
                    fontFamily: CustomFonts.regular,
                    fontSize: 11,
                    color: Color(CustomColors.error)
                  ),
                )
              ],
            ),
          ),
        );
      }
  );
}
