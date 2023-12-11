library globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'data/unit.dart';
import 'data/unit_health.dart';

double fontSize = 14;
UserCredential? curCred;
DatabaseReference? fireRef;
int selectedLocationIndex = 1;

List<Unit> units = [
  //Unit.simple('mook1', UnitHealth.empty()),
  //Unit.simple('mook2', UnitHealth.empty()),
  //Unit.simple('mook3', UnitHealth.empty()),
];
