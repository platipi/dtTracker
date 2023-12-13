import 'dart:math';

import 'package:dt_tracker_user/pages/unit_page/widgets/change_sp.dart';
import 'package:dt_tracker_user/pages/widgets/rect_button.dart';
import 'package:dt_tracker_user/utilities/data/data_firebase_functions.dart';
import 'package:dt_tracker_user/utilities/data/data_functions.dart';
import 'package:dt_tracker_user/utilities/data/data_types.dart';
import 'package:dt_tracker_user/utilities/data/unit.dart';
import 'package:dt_tracker_user/utilities/data/unit_health.dart';
import 'package:dt_tracker_user/utilities/globals.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

class AddUnitState extends StatefulWidget {
  Function refreshParent;
  AddUnitState(this.refreshParent, {super.key});
  @override
  AddUnitWidget createState() => AddUnitWidget(refreshParent);
}

class AddUnitWidget extends State<AddUnitState> {
  Function refreshParent;
  final _controller = PageController();
  int curPageIndex = 0;
  int pagesLength = 4;
  String name = '';
  List<ArmorLocation> armor = [
    ArmorLocation.blank(),
    ArmorLocation.blank(),
    ArmorLocation.blank(),
    ArmorLocation.blank(),
    ArmorLocation.blank(),
    ArmorLocation.blank()
  ];
  List<bool> armorChanged = List.filled(6, false);
  Map<String, int> stats = {'Body': 6, 'Ref': 6, 'MA': 6, 'WS': 10, 'Other': 9};

  AddUnitWidget(this.refreshParent);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      onPageChanged: ((index) {
        curPageIndex = index;
      }),
      children: [
        AddUnitPage(
          index: 0,
          alignment: MainAxisAlignment.center,
          children: [
            Text(
              curCred != null ? 'New Unit' : 'Must Login',
              style: TextStyle(fontSize: fontSize * 2),
            ),
            if (curCred != null)
              Container(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  child: TextField(
                    onChanged: ((String value) => (name = value)),
                  ))
          ],
        ),
        AddUnitPage(index: 1, children: [
          GestureDetector(
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return changeSpWidget(armor, 10, (() {}));
                  }),
              child: Text(
                'Armor',
                style: TextStyle(fontSize: fontSize * 2),
              )),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
            children: armor.mapIndexedAndLast((index, location, last) {
              return Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 90,
                        ),
                        Text(
                          locationToString(index),
                          style: TextStyle(fontSize: fontSize * 1.4),
                        ),
                        Row(children: [
                          Checkbox(
                              value: armor[index].isHard,
                              onChanged: ((value) {
                                setState(() {
                                  armor[index].isHard = !armor[index].isHard;
                                });
                              })),
                          Text('Hard'),
                          SizedBox(
                            width: 10,
                          )
                        ])
                      ]),
                  Row(
                    children: [
                      ExpandedRectButton('0', (() {
                        changeSp(false, 0, index);
                      }), smallButtonHeight),
                      ExpandedRectButton('--', (() {
                        changeSp(true, -5, index);
                      }), smallButtonHeight),
                      ExpandedRectButton('-', (() {
                        changeSp(true, -1, index);
                      }), smallButtonHeight),
                      TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0),
                            minimumSize: Size(30, 30)),
                        onPressed: (() {
                          //hard enter value
                        }),
                        child: Text(
                          '${armor[index].maxSp}',
                          style: TextStyle(
                              color: Colors.black, fontSize: fontSize * 1.25),
                        ),
                      ),
                      ExpandedRectButton('+', (() {
                        setState(() {
                          changeSp(true, 1, index);
                        });
                      }), smallButtonHeight),
                      ExpandedRectButton('++', (() {
                        changeSp(true, 5, index);
                      }), smallButtonHeight),
                      ExpandedRectButton('14', (() {
                        changeSp(false, 14, index);
                      }), smallButtonHeight),
                    ],
                  ),
                ],
              );
            }).toList(),
          )))
        ]),
        AddUnitPage(
          index: 2,
          children: [
            Text(
              'Stats & Skills',
              style: TextStyle(fontSize: fontSize * 2),
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
              children: stats.mapTo((statKey, statValue) {
                return Column(
                  children: [
                    Text(
                      statKey,
                      style: TextStyle(fontSize: fontSize * 1.4),
                    ),
                    Row(
                      children: [
                        ExpandedRectButton('3', (() {
                          setState(() {
                            stats[statKey] = 3;
                          });
                        }), smallButtonHeight),
                        ExpandedRectButton('-', (() {
                          setState(() {
                            stats[statKey] = max(statValue - 1, 0);
                          });
                        }), smallButtonHeight),
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              minimumSize: Size(30, 30)),
                          onPressed: (() {
                            //hard enter value
                          }),
                          child: Text(
                            statValue.toString(),
                            style: TextStyle(
                                color: Colors.black, fontSize: fontSize * 1.25),
                          ),
                        ),
                        ExpandedRectButton('+', (() {
                          setState(() {
                            stats[statKey] = statValue + 1;
                          });
                        }), smallButtonHeight),
                        ExpandedRectButton('10', (() {
                          setState(() {
                            stats[statKey] = 10;
                          });
                        }), smallButtonHeight),
                      ],
                    ),
                  ],
                );
              }).toList(),
            )))
          ],
        ),
        AddUnitPage(
          index: 3,
          children: [],
        ),
      ],
    );
  }

  void SubmitUnit() {
    List<String> curNames = units.map((e) => e.name).toList();
    while (name.isEmpty || curNames.contains(name)) {
      name = GetRandomName();
    }
    Unit unit = Unit.simple(name, UnitHealth.empty());
    unit.unitHealth.armor = armor;
    unit.unitHealth.body = stats['Body']!;
    for (var stat in unit.battleStats.entries) {
      if (stats[stat.key] != null) {
        unit.battleStats[stat.key] = stats[stat.key];
      } else if (stat.key != 'Utility') {
        unit.battleStats[stat.key] = stats['Other'];
      }
    }
    for (var stat in unit.floofStats.entries) {
      if (stats[stat.key] != null) {
        unit.floofStats[stat.key] = stats[stat.key];
      } else if (stat.key != 'Notes') {
        unit.floofStats[stat.key] = stats['Other'];
      }
    }

    units.insert(0, unit);
    //saveData(context);
    ResetAddUnit();
  }

  ResetAddUnit() {
    name = '';
    armor = [
      ArmorLocation.blank(),
      ArmorLocation.blank(),
      ArmorLocation.blank(),
      ArmorLocation.blank(),
      ArmorLocation.blank(),
      ArmorLocation.blank()
    ];
    armorChanged = List.filled(6, false);
    stats = {'Body': 6, 'Ref': 6, 'MA': 6, 'WS': 10, 'Other': 9};
    _controller.animateTo(0,
        duration: const Duration(milliseconds: 1), curve: Curves.easeIn);
    refreshParent(index: 2);
  }

  Widget AddUnitPage(
      {required List<Widget> children,
      required int index,
      MainAxisAlignment? alignment}) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: alignment ?? MainAxisAlignment.start,
                children: children,
              )),
              Row(
                children: [
                  if (index > 1)
                    ExpandedRectButton('<', () {
                      _controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    }, bigButtonHeight),
                  if (index != 0)
                    ExpandedRectButton('Finish', () {
                      SubmitUnit();
                      saveData(context);
                    }, bigButtonHeight),
                  if (index == 0 && curCred != null)
                    ExpandedRectButton('+', () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    }, bigButtonHeight),
                  if (index != pagesLength - 1 && index != 0)
                    ExpandedRectButton('>', () {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    }, bigButtonHeight)
                ],
              )
              // ExpanRectButton(
              //   Text('>'),
              //   onPressed: () {},
              //   width: 50,
              //   height: 230,
              // ),
              //)
            ])),
      ],
    );
  }

  void changeSp(bool increment, int value, int index) {
    armorChanged[index] = true;
    int newVal;
    if (!increment) {
      newVal = value;
    } else {
      newVal = armor[index].maxSp + value;
      newVal = max(0, newVal);
    }
    setState(() {
      armor[index].setSp(newVal);
      for (var i = index + 1; i < armor.length; i++) {
        if (!armorChanged[i]) {
          bool isArmAndPreviousChanged =
              (i == 3 || i == 5) && armorChanged[i - 1] && index != i - 1;
          if (!isArmAndPreviousChanged) {
            armor[i].setSp(newVal);
          }
        }
        if (index == 2 || index == 4) {
          //if changing arm/leg only change next
          break;
        }
      }
    });
  }
}
