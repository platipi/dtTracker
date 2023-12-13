// ignore_for_file: non_constant_identifier_names

import 'package:dt_tracker_user/utilities/globals.dart';
import 'package:flutter/material.dart';

Widget ExpandedRectButton(String text, VoidCallback? onPressed, double height,
    {int? flexWeight}) {
  return Expanded(
      flex: flexWeight ?? 1,
      child: RectButton(
          Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: fontSize * 1.25),
          ),
          onPressed: onPressed,
          height: height));
}

Widget RectButton(Widget child,
    {VoidCallback? onPressed, double? width, double? height}) {
  return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(3),
      child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(onPressed != null
                ? Colors.white
                : Color.fromRGBO(40, 40, 40, 1)), //better effect later
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.black, width: 4.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(2)))),
          ),
          onPressed: onPressed,
          child: child
          //  Text(
          //   child,
          //   style: TextStyle(color: Colors.black, fontSize: fontSize * 1.25),
          //),
          ));
}
