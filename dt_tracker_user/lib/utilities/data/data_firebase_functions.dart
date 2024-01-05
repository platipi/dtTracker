import 'dart:convert';

import 'package:dt_tracker_user/utilities/data/data_types.dart';
import 'package:dt_tracker_user/utilities/data/unit.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../globals.dart';

Future<void> updateUser([Function? refreshParent]) async {
  fireRef = FirebaseDatabase.instance.ref('${curCred!.user!.uid}');
  await loadData();
  if (refreshParent != null) {
    refreshParent();
  }
}

Future<void> loadData() async {
  var snapshot = await fireRef?.get();
  if (snapshot != null) {
    var items = jsonDecode(snapshot.value.toString());
    int index = 0;
    units = [];
    bool nextValid() {
      bool valid = false;
      try {
        if (items[index] == null) {
          valid = false;
        }
        valid = true;
      } catch (e) {
        //print(e);
      }
      return valid;
    }

    ;
    // print(items);
    // print('========================');
    while (nextValid()) {
      //print(items[index]);
      //print('========================');
      units.add(Unit.fromJson(items[index]));

      index++;
    }
    // print(items);
    // units = items.map((item) => Unit.fromJson(item)).toList();
    // print(units[0]);
  }
}

Future<void> saveData(context, {bool showSaving = false}) async {
  if (curCred != null) {
    if (showSaving) {
      try {
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(content: Text('Saving...')),
        );
      } catch (e) {}
    }

    await fireRef!.remove();
    await fireRef!.set(json.encode(units));

    if (showSaving) {
      try {
        ScaffoldMessenger.of(context!).hideCurrentSnackBar();
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(
              content: Text('Saved!'), duration: Duration(milliseconds: 500)),
        );
      } catch (e) {}
    }
  }
}
