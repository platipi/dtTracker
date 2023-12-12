import 'package:dt_tracker_user/utilities/data/data_functions.dart';
import 'package:dt_tracker_user/utilities/data/data_types.dart';
import 'package:dt_tracker_user/utilities/data/unit.dart';
import 'package:flutter/material.dart';

Widget changeSpWidget(
    List<ArmorLocation> armor, int location, Function refreshParent) {
  String spValue = '';

  int validateSp(String value) {
    if (location != 10) {
      if (int.tryParse(spValue) != null) {
        return int.tryParse(spValue)!;
      }
    } else {
      List<String> inList = spValue.split(',');
      if (inList.length > 6 || inList.isEmpty) {
        return -1;
      }
      for (var val in inList) {
        if (int.tryParse(val) == null) {
          return -1;
        } else if (int.parse(val) < 0) {
          return -1;
        }
      }
      return 1;
    }
    return -1;
  }

  void setSp(bool updateMax) {
    if (location == 10) {
      List<String> inList = spValue.split(',');
      List<ArmorLocation> armors = armor;
      if (inList.length == 1) {
        for (var armor in armors) {
          armor.setSp(int.parse(inList[0]));
        }
      } else if (inList.length == 2) {
        armors[0].setSp(int.parse(inList[0]));
        for (var i = 1; i < armors.length; i++) {
          armors[i].setSp(int.parse(inList[1]));
        }
      } else if (inList.length == 3) {
        armors[0].setSp(int.parse(inList[0]));
        armors[1].setSp(int.parse(inList[1]));
        armors[2].setSp(int.parse(inList[1]));
        armors[3].setSp(int.parse(inList[1]));
        armors[4].setSp(int.parse(inList[2]));
        armors[5].setSp(int.parse(inList[2]));
      } else if (inList.length == 4) {
        armors[0].setSp(int.parse(inList[0]));
        armors[1].setSp(int.parse(inList[1]));
        armors[2].setSp(int.parse(inList[2]));
        armors[3].setSp(int.parse(inList[2]));
        armors[4].setSp(int.parse(inList[3]));
        armors[5].setSp(int.parse(inList[3]));
      } else if (inList.length == 5) {
        armors[0].setSp(int.parse(inList[0]));
        armors[1].setSp(int.parse(inList[1]));
        armors[2].setSp(int.parse(inList[2]));
        armors[3].setSp(int.parse(inList[3]));
        armors[4].setSp(int.parse(inList[4]));
        armors[5].setSp(int.parse(inList[4]));
      } else if (inList.length == 6) {
        for (var i = 0; i < armors.length; i++) {
          armors[i].setSp(int.parse(inList[i]));
        }
      }
    } else {
      if (updateMax) {
        armor[location].maxSp = validateSp(spValue);
      }
      armor[location].curSp = validateSp(spValue);
    }
    refreshParent();
  }

  return StatefulBuilder(builder: (context, setState) {
    return AlertDialog(
      title: Text('Change ${locationToString(location)} SP'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          onChanged: (value) {
            setState(() => spValue = value);
          },
        ),
      ]),
      actionsAlignment: MainAxisAlignment.start,
      actions: <Widget>[
        if (validateSp(spValue) < 0)
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
        if (location != 10 && validateSp(spValue) >= 0)
          TextButton(
            onPressed: () {
              setSp(false);
              Navigator.pop(context);
            },
            child: const Text('Set Current'),
          ),
        if (validateSp(spValue) >= 0)
          TextButton(
            onPressed: () {
              setSp(true);
              Navigator.pop(context);
            },
            child: const Text('Set Max'),
          ),
      ],
    );
  });
}
