import 'package:dt_tracker_user/utilities/data/unit.dart';
import 'package:flutter/material.dart';

void AlertChangeStat(
    {required BuildContext context,
    required String title,
    required Unit unit,
    required String statKey,
    required Function updateParent,
    MainAxisAlignment? actionsAlignment,
    List<Widget>? actions}) {
  String tempVal = '';

  String returnVal(String? value) {
    for (var stat in unit.battleStats.entries) {
      if (statKey == stat.key) {
        if (value != null) {
          unit.battleStats[statKey] = value;
          updateParent();
        }
        return unit.battleStats[statKey].toString();
      }
    }
    for (var stat in unit.gunStats.entries) {
      if (statKey == stat.key) {
        if (value != null) {
          unit.gunStats[statKey] = value;
          updateParent();
        }

        return unit.gunStats[statKey].toString();
      }
    }
    for (var stat in unit.floofStats.entries) {
      if (statKey == stat.key) {
        if (value != null) {
          unit.floofStats[statKey] = value;
          updateParent();
        }
        return unit.floofStats[statKey].toString();
      }
    }
    return '';
    print('key not found 0o0');
  }

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(
                initialValue: returnVal(null),
                onChanged: (value) {
                  setState(() {
                    tempVal = value;
                  });
                },
              ),
            ]),
            actionsAlignment: actionsAlignment ?? MainAxisAlignment.start,
            actions: actions ??
                [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  if (tempVal.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'Confirm');
                        returnVal(tempVal);
                        updateParent();
                      },
                      child: const Text('Confirm'),
                    ),
                ],
          );
        });
      });
}
