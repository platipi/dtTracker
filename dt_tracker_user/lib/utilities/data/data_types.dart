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
