import 'dart:math';

import 'package:dt_tracker_user/utilities/data/unit_health.dart';

enum UnitType { wildcard, base, mook }

enum Status { stun, uncon, dead }

class APType {
  String name = "Normal";
  double softArmorMod = 1;
  double softDmgMod = 1;
  double hardArmorMod = 1;
  double hardDmgMod = 1;
  Function extraEffect = (APInfo info, UnitHealth unit) =>
      (); //return APInfo, do inheritance crap on unit
}

class APInfo {
  bool isBar = false;
  bool isHard;
  int armor = 0;
  int dmg = 0;

  APInfo(this.isBar, this.isHard, this.armor, this.dmg);
}

int objtoint(var obj) {
  return int.tryParse(obj.toString())!;
}

class Barrier {
  List<int> locations = [];
  int sp = 0;

  Barrier(this.locations, this.sp);
}

class ArmorLocation {
  int maxSp = 0;
  int curSp = 0;
  bool isHard = false;
  bool critInjury = false;
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
