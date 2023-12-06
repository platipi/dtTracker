import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

int objtoint(var obj) {
  return int.tryParse(obj.toString())!;
}

Color getColorFromDamage(double percent) {
  if (percent >= 0.9) {
    return Colors.yellow;
  } else if (percent >= 0.6) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}

int rollD10() {
  int roll = Random().nextInt(10) + 1;
  int total = roll;
  if (roll == 1) {
    do {
      roll = Random().nextInt(10) + 1;
      total -= roll;
    } while (roll == 10);
  } else if (roll == 10) {
    do {
      roll = Random().nextInt(10) + 1;
      total += roll;
    } while (roll == 10);
  }
  return total;
}

String locationToString(int location) {
  switch (location) {
    case 0:
      return "Head";
    case 1:
      return "Torso";
    case 2:
      return "Left Arm";
    case 3:
      return "Right Arm";
    case 4:
      return "Left Leg";
    case 5:
      return "Right Leg";
    default:
      return "Invalid";
  }
}
