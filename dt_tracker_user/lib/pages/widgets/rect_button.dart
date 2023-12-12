import 'package:dt_tracker_user/utilities/globals.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget ExpandedRectButton(String text, VoidCallback? onPressed, double height) {
  return Expanded(
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
                : Color.fromRGBO(40, 40, 40, 1)),
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
