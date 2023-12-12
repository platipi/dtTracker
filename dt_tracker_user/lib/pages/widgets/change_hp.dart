import 'dart:math';

import 'package:dt_tracker_user/pages/widgets/shot_button.dart';
import 'package:dt_tracker_user/utilities/data/data_functions.dart';
import 'package:dt_tracker_user/utilities/data/data_types.dart';
import 'package:dt_tracker_user/utilities/data/unit.dart';
import 'package:dt_tracker_user/utilities/globals.dart';
import 'package:flutter/material.dart';

Widget changeHpWidget(Unit unit, Function refreshParent) {
  String hpInput = '';
  int hpValue = unit.unitHealth.damageTaken;
  double smallButtonHeight = 50;

  int validateHp() {
    int? val = int.tryParse(hpInput);
    if (val != null) {
      if (val >= 0) {
        return val;
      }
    }
    return -1;
  }

  return StatefulBuilder(builder: (context, setState) {
    return AlertDialog(
      title: Text('Change ${unit.name} HP'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        // TextField(
        //   onChanged: (value) {
        //     setState(() => hpValue = value);
        //   },
        // ),
        Row(
          children: [
            RectButton('0', (() {
              setState(() {
                hpValue = 0;
              });
            }), smallButtonHeight),
            RectButton('v', (() {
              setState(() {
                hpValue = max(hpValue - 5, 0);
              });
            }), smallButtonHeight),
            RectButton('-', (() {
              setState(() {
                hpValue = max(hpValue - 1, 0);
              });
            }), smallButtonHeight),
            // TextButton(
            //     style: TextButton.styleFrom(
            //         padding: EdgeInsets.all(0), minimumSize: Size(30, 30)),
            //     onPressed: (() {
            //       //hard enter value
            //     }),
            //     child:
            Text(
              '${hpValue}',
              style: TextStyle(color: Colors.black, fontSize: fontSize * 1.25),
            ),
            //),
            RectButton('+', (() {
              setState(() {
                hpValue = min(hpValue + 1, 50);
              });
            }), smallButtonHeight),
            RectButton('^', (() {
              setState(() {
                hpValue = min(hpValue + 5, 50);
              });
            }), smallButtonHeight),
            RectButton('D', (() {
              setState(() {
                hpValue = 50;
              });
            }), smallButtonHeight),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          children: Status.values.map((e) {
            return Row(
              children: [
                Checkbox(
                    value: unit.unitHealth.statuses.contains(e),
                    onChanged: ((value) {
                      if (unit.unitHealth.statuses.contains(e)) {
                        setState(() {
                          unit.unitHealth.statuses.remove(e);
                        });
                      } else {
                        setState(() {
                          unit.unitHealth.statuses.add(e);
                        });
                      }
                    })),
                Text(e.name)
              ],
            );
          }).toList(),
          // [

          //   Row(
          //     children: [
          //       Checkbox(
          //           value: unit.unitHealth.statuses.contains(Status.stun),
          //           onChanged: ((value) {
          //             if (unit.unitHealth.statuses.contains(Status.stun)) {
          //               setState(() {
          //                 unit.unitHealth.statuses.remove(Status.stun);
          //               });
          //             } else {
          //               setState(() {
          //                 unit.unitHealth.statuses.add(Status.stun);
          //               });
          //             }
          //           })),
          //       Text('Stunned')
          //     ],
          //   ),
          //   Row(
          //     children: [
          //       Checkbox(
          //           value: unit.unitHealth.statuses.contains(Status.uncon),
          //           onChanged: ((value) {
          //             if (unit.unitHealth.statuses.contains(Status.uncon)) {
          //               setState(() {
          //                 unit.unitHealth.statuses.remove(Status.uncon);
          //               });
          //             } else {
          //               setState(() {
          //                 unit.unitHealth.statuses.add(Status.uncon);
          //               });
          //             }
          //           })),
          //       Text('Uncon')
          //     ],
          //   ),
          //   Row(
          //     children: [
          //       Checkbox(
          //           value: unit.unitHealth.statuses.contains(Status.dead),
          //           onChanged: ((value) {
          //             if (unit.unitHealth.statuses.contains(Status.uncon)) {
          //               setState(() {
          //                 unit.unitHealth.statuses.remove(Status.uncon);
          //               });
          //             } else {
          //               setState(() {
          //                 unit.unitHealth.statuses.add(Status.uncon);
          //               });
          //             }
          //           })),
          //       Text('Dead')
          //     ],
          //   )
          // ],
        )
      ]),
      actionsAlignment: MainAxisAlignment.start,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            unit.unitHealth.damageTaken = hpValue;
            refreshParent();
            Navigator.pop(context);
          },
          child: const Text('Set HP'),
        ),
      ],
    );
  });
}
