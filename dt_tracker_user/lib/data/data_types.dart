enum UnitType { wildcard, base, mook }

enum Status { stun, uncon, dead }

class APType {
  String name = "Normal";
  double softArmorMod = 1;
  double softDmgMod = 1;
  double hardArmorMod = 1;
  double hardDmgMod = 1;
  Function extraEffect = (isHard, armor, health) => ();
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
}
