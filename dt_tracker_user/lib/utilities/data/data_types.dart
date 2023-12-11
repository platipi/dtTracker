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

  Map toJson() {
    return {'locations': locations, 'sp': sp};
  }

  Barrier(this.locations, this.sp);

  factory Barrier.fromJson(dynamic json) {
    return Barrier(json['locations'] as List<int>, json['sp'] as int);
  }
}

class ArmorLocation {
  int maxSp = 0;
  int curSp = 0;
  bool isHard = false;
  String critInjury = 'false';

  void setSp(int sp) {
    maxSp = sp;
    curSp = sp;
  }

  Map toJson() {
    return {
      'maxSp': maxSp,
      'curSp': curSp,
      'isHard': isHard,
      'critInjury': critInjury
    };
  }

  ArmorLocation.blank() {}

  ArmorLocation.simple(sp, this.isHard) {
    maxSp = sp;
    curSp = sp;
  }

  ArmorLocation(this.maxSp, this.curSp, this.isHard, this.critInjury) {}

  factory ArmorLocation.fromJson(dynamic json) {
    return ArmorLocation(json['maxSp'] as int, json['curSp'] as int,
        json['isHard'] as bool, json['critInjury'] as String);
  }
}
