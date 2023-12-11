import 'package:dt_tracker_user/utilities/globals.dart';
import 'package:flutter/material.dart';

Widget RectButton(String text, Function onPressed) {
  return Expanded(
      child: Container(
          width: double.infinity,
          height: 80,
          padding: const EdgeInsets.all(8),
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.black,
                      width: 4.0,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(2)))),
            ),
            onPressed: (() {
              onPressed();
            }),
            child: Text(
              text,
              style: TextStyle(color: Colors.black, fontSize: fontSize * 1.25),
            ),
          )));
}
