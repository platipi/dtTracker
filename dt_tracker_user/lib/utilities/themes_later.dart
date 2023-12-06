import 'package:flutter/material.dart';

ButtonStyle customSideButton() {
  return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      iconSize: MaterialStateProperty.all(32),
      iconColor: MaterialStateProperty.all(Colors.black),
      shape: MaterialStateProperty.all(const RoundedRectangleBorder(
        side: BorderSide(
            color: Colors.black, width: 3.0, style: BorderStyle.solid),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(100),
          topRight: Radius.circular(0),
        ),
      )));
}
