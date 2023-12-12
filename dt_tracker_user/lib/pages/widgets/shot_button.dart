import 'package:dt_tracker_user/utilities/globals.dart';
import 'package:flutter/material.dart';

Widget RectButton(String text, VoidCallback? onPressed, double height) {
  return Expanded(
      child: Container(
          width: double.infinity,
          height: height,
          padding: const EdgeInsets.all(3),
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(onPressed != null
                  ? Colors.white
                  : Color.fromRGBO(40, 40, 40, 1)),
              shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.black,
                      width: 4.0,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(2)))),
            ),
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(color: Colors.black, fontSize: fontSize * 1.25),
            ),
          )));
}
