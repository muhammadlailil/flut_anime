import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pertama/src/constant/colors.dart';
import 'package:pertama/src/constant/fonts.dart';
import 'package:pertama/src/ui/home/home_screen.dart';
import 'package:pertama/src/ui/home/watch_anime.dart';

import 'home/search_screen.dart';

appBar(BuildContext context){
  return AppBar(
    elevation : 0,
//    automaticallyImplyLeading: false,
    backgroundColor: Color(0xFF31336F),
    title: Container(
      height: 40,
      child: TextFormField(
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (value) {
          if(value!=""){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen(search: value,)),
            );
          }
        },
        decoration: InputDecoration(
          fillColor: Color(CustomColors.inputColor),
          hintText: "Search Anime ..",
          hintStyle: TextStyle(
              fontFamily: CustomFonts.regular,
              fontSize: 15,
              color: Color(CustomColors.inputTextColor)
          ),
          filled: true,
          contentPadding: EdgeInsets.only(left: 15, bottom: 2, top: 2,right: 15),
          focusedBorder: OutlineInputBorder(
            borderRadius:  BorderRadius.circular(4),
            borderSide: BorderSide(
                width: 0,
                color: Color(CustomColors.inputBorder)
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius:  BorderRadius.circular(4),
            borderSide: BorderSide(
                width: 0.8,
                color: Color(CustomColors.error)
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius:  BorderRadius.circular(4),
            borderSide: BorderSide(
                width: 0.8,
                color: Color(CustomColors.error)
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:  BorderRadius.circular(4),
            borderSide: BorderSide(
                width: 0.8,
                color: Color(CustomColors.inputBorder)
            ),
          ),
        ),
      ),
    ),
//    actions: <Widget>[
//      IconButton(
//        icon: Icon(Icons.home),
//        onPressed: () {
//          Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => HomeScreen()),
//          );
//        },
//      ),
//    ],
  );
}