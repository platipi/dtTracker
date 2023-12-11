import 'dart:convert';
import 'dart:math';
import 'package:dt_tracker_user/utilities/data/data_types.dart';
import 'package:dt_tracker_user/utilities/data/data_functions.dart';

void main() {
  for (var i = 0; i < 100; i++) {
    print(rollD10());
  }
}

class UnitHealth {
  UnitType unitType = UnitType.base;
  int body = 6;
  int damageTaken = 0;

  List<ArmorLocation> armor = [
    ArmorLocation.blank(),
    ArmorLocation.blank(),
    ArmorLocation.blank(),
    ArmorLocation.blank(),
    ArmorLocation.blank(),
    ArmorLocation.blank()
  ];
  List<Barrier> bar = []; //list of bar locations
  List<Status> statuses = [];

  int btm() {
    if (body > 10) {
      return 5;
    } else if (body < 6) {
      return (body / 2 - 1).ceil();
    } else {
      return (body / 2 - 1).floor();
    }
  }

  List<String> dealDamage(int damage, int location, APType apType) {
    List<String> returnList = [];
    int tempdmg;

    //subtract barrier
    for (var i = 0; i < bar.length; i++) {
      for (var o = 0; i < bar[i].locations.length; o++) {
        tempdmg = damage;
        if (bar[i].locations[o] == location) {
          //extra effect
          APInfo info = APInfo(true, true, bar[i].sp, damage);
          apType.extraEffect(info, this);
          damage = info.dmg;

          //damage - barrier
          damage -= (bar[i].sp * apType.hardArmorMod).floor();
          damage = max(damage, 0);

          bar[i].sp = info.armor;

          //damage barrier
          if (tempdmg >= (bar[i].sp / 2).floor()) {
            returnList.add("Barrier Damaged #: ${i + 1}");
            bar[i].sp--;
          } //end if barrier damage

          //if no damage left
          if (damage <= 0) {
            returnList.add("Stopped by barrier #: ${i + 1}");
            return returnList;
          }
          break;
        } //end if correct location
      }
    } //end for each barrier

    //location damage

    //damage through armor
    ArmorLocation hitLocation = armor[location];
    tempdmg = damage;
    var armorMod =
        hitLocation.isHard ? apType.hardArmorMod : apType.softArmorMod;
    damage -= (hitLocation.curSp * armorMod).floor();

    //armor degredation
    if (tempdmg >= (hitLocation.curSp / 2).floor()) {
      armor[location].curSp--;
      returnList.add("Armor degraded to ${armor[location].curSp}");
    }

    //returnlist
    if (damage <= 0) {
      returnList.add("Stopped by ${locationToString(location)}");
    } else if (damage > 0) {
      returnList.add("Damage through!");
    }

    tempdmg = damage; //temp dmg = dmg thorugh

    //damage modifications declared for re-ordering
    var dmgMod = hitLocation.isHard ? apType.hardDmgMod : apType.softDmgMod;
    void dmgPositiveAP() {
      if (dmgMod >= 1) {
        damage = (damage * dmgMod).floor();
      }
    }

    void dmgNegativeAP() {
      if (dmgMod < 1) {
        damage = (damage * dmgMod).floor();
      }
    }

    void dmgDoubleIfHead() {
      if (location == 0) {
        damage *= 2;
      }
    }

    void dmgBtm() {
      //if negative dmg mod: min dmg of 0
      damage = max(damage - btm(), dmgMod < 1 ? 0 : 1);
    }

    void dmgExtra() {
      APInfo info = APInfo(false, hitLocation.isHard, hitLocation.curSp,
          tempdmg); //(tempdmg=dmg through armor)
      info = apType.extraEffect(info, this);
      armor[location].curSp -= hitLocation.curSp - info.armor;
      damage += tempdmg - info.dmg;
    }

    void checkIfCritInjury() {
      if (location != 1) {
        if (damage >= 8) {
          armor[location].critInjury = 'true';
          returnList.add("Critical Injury to ${locationToString(location)}");
          if (location == 0) {
            statuses.add(Status.dead);
            returnList.add("Headshot Insta-Kill!!!");
          }
        }
      } else if (damage >= 15) {
        armor[location].critInjury = 'true';
        returnList.add("Critical Injury to ${locationToString(location)}");
      }
    }

    //calcuate damage in correct order
    switch (unitType) {
      case UnitType.wildcard:
        dmgPositiveAP();
        dmgNegativeAP();
        dmgBtm();
        checkIfCritInjury();
        dmgDoubleIfHead();
        dmgExtra();
        break;
      case UnitType.mook:
        dmgPositiveAP();
        dmgDoubleIfHead();
        checkIfCritInjury();
        dmgNegativeAP();
        dmgBtm();
        dmgExtra();
        break;
      default:
        dmgPositiveAP();
        dmgNegativeAP();
        dmgDoubleIfHead();
        dmgBtm();
        checkIfCritInjury();
        dmgExtra();
    }

    if (damage > 0) {
      returnList.add("${damage} through to ${locationToString(location)}");
      var stunUncon = rollStun();
      if (stunUncon.contains(Status.stun)) {
        returnList.add("Stunned!");
      }
      if (stunUncon.contains(Status.uncon)) {
        returnList.add("Unconscious!!");
      }
      if (stunUncon.contains(Status.dead)) {
        returnList.add("Dealt more than 50 dmg?!?!? OwO");
      }
    }

    return returnList;
  } //end Deal Damage end Deal Damage end Deal Damage end Deal Damage end Deal Damage end Deal Damage

  int stunMod() {
    return ((damageTaken - 1) / 5).floor();
  }

  int unconMod() {
    return max(stunMod() - 3, 0);
  }

  List<Status> rollStun() {
    List<Status> returnList = List.empty();
    if (!statuses.contains(Status.stun)) {
      if (rollD10() > body - stunMod()) {
        returnList.add(Status.stun);
      }
    }
    if (statuses.contains(Status.stun) &&
        damageTaken > 15 &&
        !statuses.contains(Status.uncon)) {
      if (rollD10() > body - unconMod()) {
        returnList.add(Status.uncon);
      }
    }
    if (damageTaken > 50) {
      returnList.add(Status.dead);
    }
    return returnList;
  }

  UnitHealth.empty() {}

  Map toJson() {
    List<Map> armor = this.armor.map((i) => i.toJson()).toList();
    List<Map>? bar = this.bar.map((i) => i.toJson()).toList();
    List<int>? statuses = this.statuses.map((i) => i.index).toList();

    return {
      'unitType': unitType.index,
      'body': body,
      'damageTaken': damageTaken,
      'armor': armor,
      'bar': bar,
      'statuses': statuses
    };
  }

  UnitHealth(this.unitType, this.body, this.damageTaken, this.armor, this.bar,
      this.statuses);

  factory UnitHealth.fromJson(dynamic json) {
    var tempJson = json['armor'] as List;
    List<ArmorLocation> armor =
        tempJson.map((itemJson) => ArmorLocation.fromJson(itemJson)).toList();
    tempJson = json['bar'] as List;
    List<Barrier> bar =
        tempJson.map((itemJson) => Barrier.fromJson(itemJson)).toList();

    List<Status> statuses = [];
    if (json['statuses'] != null) {
      tempJson = json['statuses'];
      List<Status> statuses =
          tempJson.map((itemJson) => Status.values[itemJson]).toList();
    }

    return UnitHealth(UnitType.values[json['unitType'] as int],
        json['body'] as int, json['damageTaken'] as int, armor, bar, statuses);
  }
}
