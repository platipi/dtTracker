library globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'data/unit.dart';
import 'data/unit_health.dart';

double fontSize = 14;
UserCredential? curCred;
DatabaseReference? fireRef;
int selectedLocationIndex = 1;
double smallButtonHeight = 50;
double bigButtonHeight = 80;

List<String> randomNames = [];

List<Unit> units = [
  //Unit.simple('mook1', UnitHealth.empty()),
  //Unit.simple('mook2', UnitHealth.empty()),
  //Unit.simple('mook3', UnitHealth.empty()),
];
