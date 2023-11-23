import 'dart:ffi';
import 'package:dt_tracker_user/data/data_types.dart';

class Unit {
  String name = "Unnamed";
  UnitType unitType = UnitType.base;
  List<ArmorLocation> armor = List.filled(6, ArmorLocation());
  List<Barrier> bar = []; //list of bar locations written as [locations]
  int body = 6;
  int damageTaken = 0;
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

    //subtract barrier
    for (var i = 0; i < bar.length; i++) {
      for (var o = 0; i < bar[i].locations.length; o++) {
        var tempdmg = damage;
        if (bar[i].locations[o] == location) {
          damage -= (bar[i].sp * apType.hardArmorMod).floor();

          if (tempdmg >= (bar[i].sp / 2).floor()) {
            returnList.add("Barrier ${i + 1} Damaged");
            bar[i].sp--;
          } //end if barrier damage
          break;
        } //end if correct location
      }
    }
    return returnList;
  }

  Unit() {}
}
