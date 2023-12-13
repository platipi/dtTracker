import 'dart:math';

import 'package:dt_tracker_user/pages/unit_page/widgets/change_hp.dart';
import 'package:dt_tracker_user/pages/unit_page/widgets/change_sp.dart';
import 'package:dt_tracker_user/pages/widgets/rect_button.dart';
import 'package:dt_tracker_user/pages/unit_page/widgets/unit_statblock.dart';
import 'package:dt_tracker_user/utilities/data/data_firebase_functions.dart';
import 'package:dt_tracker_user/utilities/data/data_functions.dart';
import 'package:dt_tracker_user/utilities/data/data_types.dart';
import 'package:dt_tracker_user/utilities/data/unit.dart';
import 'package:dt_tracker_user/utilities/globals.dart';
import 'package:dt_tracker_user/utilities/themes_later.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnitState extends StatefulWidget {
  final Unit unit;
  Function refreshParent;
  UnitState({super.key, required this.unit, required this.refreshParent});

  @override
  UnitWidget createState() => UnitWidget(refreshParent);
}

class UnitWidget extends State<UnitState> {
  //const UnitWidget({super.key, required this.unit});
  String bottomWidget = 'battleStats';
  int numOfDmg = 0;
  int bonusDmg = 0;
  int dieType = 6;
  int shotCount = 0;
  bool rollDmg = false;
  late Function refreshUnit;
  Function refreshParent;
  List<String> report = [];

  UnitWidget(this.refreshParent);

  void resetData() {
    selectedLocationIndex = -1;
    numOfDmg = 0;
    bonusDmg = 0;
    dieType = 6;
    shotCount = 0;
    rollDmg = false;
  }

  @override
  void initState() {
    super.initState();
    selectedLocationIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    Unit unit = widget.unit;
    double screenWidth = 450;

    refreshUnit = () {
      if (bottomWidget == 'report') {
        saveData(context, showSaving: false);
      } else {
        saveData(context);
      }

      setState(() {});
    };

    void cycleUnitType() {
      var curUnitIndex = unit.unitHealth.unitType.index;
      unit.unitHealth.unitType = UnitType.values[(curUnitIndex - 1) % 3];
      refreshUnit();
    }

    var imgLinks = {
      0: 'assets/unit_head.png',
      1: 'assets/unit_torso.png',
      2: 'assets/unit_larm.png',
      3: 'assets/unit_rarm.png',
      4: 'assets/unit_lleg.png',
      5: 'assets/unit_rleg.png',
      -1: 'assets/unit_sp.png'
    };
    var hitPos = {
      0: HitBox(AlignmentDirectional(0.1, -1.12), width: 85, height: 60), //head
      1: HitBox(AlignmentDirectional(-0.02, -0.43),
          width: 50, height: 90), //torso
      2: HitBox(AlignmentDirectional(-0.39, -0.6),
          width: 60, height: 120), //larm
      3: HitBox(AlignmentDirectional(0.39, -0.4),
          width: 70, height: 100), //rarm
      4: HitBox(AlignmentDirectional(-0.32, 0.95),
          width: 80, height: 110), //lleg
      5: HitBox(AlignmentDirectional(0.3, 0.95), width: 80, height: 110) //rleg
    };

    var spPos = {
      0: const AlignmentDirectional(0.23, -1.03), //head
      1: const AlignmentDirectional(-0.02, -0.45), //torso
      2: const AlignmentDirectional(-0.39, -0.525), //larm
      3: const AlignmentDirectional(0.38, -0.615), //rarm
      4: const AlignmentDirectional(-0.37, 0.255), //lleg
      5: const AlignmentDirectional(0.39, 0.32), //rleg
    };

    return Center(
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(
              height: 40,
            ),
            //unit image vvv
            SizedBox(
              width: screenWidth,
              height: MediaQuery.sizeOf(context).height * 0.33,
              child: Stack(children: [
                //unit images vvv
                Stack(
                    children: imgLinks.entries.map((e) {
                  return Image(
                    image: AssetImage(e.value),
                    width: screenWidth,
                    color: getColor(unit, e.key),
                    fit: BoxFit.fitHeight,
                  );
                }).toList()), //images
                //sp values vvv
                Stack(
                    children: spPos.entries.map((e) {
                  return Container(
                      //alignment: e.value,
                      child: GestureDetector(
                          onTap: () {
                            if (bottomWidget == 'battleStats' ||
                                bottomWidget == 'floofStats') {
                              print(bottomWidget);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return changeSpWidget(unit.unitHealth.armor,
                                        e.key, refreshUnit);
                                  });
                            } else {
                              selectedLocationIndex = e.key;
                              setState(() {});
                            }
                          },
                          child: Stack(
                            children: [
                              Align(
                                alignment: hitPos[e.key]!.relPos,
                                child: Container(
                                  color: Colors.transparent,
                                  //color: Color.fromRGBO(255, 0, 0, 0.5),//show hit detection
                                  width: hitPos[e.key]!.width,
                                  height: hitPos[e.key]!.height,
                                ),
                              ),
                              Align(
                                alignment: e.value!,
                                child: Text(
                                    unit.unitHealth.armor[e.key].curSp
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: e.key == 1 &&
                                              getColor(unit, 1) != Colors.yellow
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: fontSize,
                                    )),
                              ),
                            ],
                          )));
                }).toList()),
                //unit name vvv
                Align(
                    alignment: const AlignmentDirectional(-0.95, 0.95),
                    child: Container(
                      color: Colors.white,
                      child: Text(
                        unit.name,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: fontSize * 1.4,
                        ),
                      ),
                    )), //name
                //side buttons vvv
                Align(
                    alignment: const AlignmentDirectional(1, -1),
                    child: Column(
                      children: [
                        //unit type cycling vvv
                        TextButton(
                          style: customSideButton(),
                          onPressed: () {
                            cycleUnitType();
                          },
                          child: Icon(unit.unitHealth.unitType == UnitType.mook
                              ? CupertinoIcons.chevron_compact_down
                              : unit.unitHealth.unitType == UnitType.wildcard
                                  ? CupertinoIcons.chevron_compact_up
                                  : CupertinoIcons.minus),
                        ),
                        TextButton(
                          style: customSideButton(),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return changeSpWidget(
                                      unit.unitHealth.armor, 10, refreshUnit);
                                });
                          },
                          child: Icon(CupertinoIcons.textformat_123),
                        ),
                        TextButton(
                          style: customSideButton(),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text(
                                          'Are you sure you want to delete ${unit.name}?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: Text('Cancel')),
                                        TextButton(
                                            onPressed: (() {
                                              units.remove(unit);
                                              refreshParent();
                                              saveData(context);
                                              Navigator.pop(context);
                                            }),
                                            child: Text('Confirm')),
                                      ],
                                    );
                                  });
                                });
                          },
                          child: Icon(CupertinoIcons.delete),
                        ),
                      ],
                    )), //end Unit type cycle
                //Hp
                Align(
                  alignment: const AlignmentDirectional(-1, -1),
                  child: GestureDetector(
                      onTap: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return changeHpWidget(unit, refreshUnit);
                          }),
                      child: Container(
                          color: Colors.transparent,
                          width: 70,
                          height: MediaQuery.sizeOf(context).height * 0.28,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: 50,
                                    child: Text(
                                      'HP:${unit.unitHealth.damageTaken}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.black),
                                    )),
                                Column(
                                  children: List.generate(
                                      min(
                                          (unit.unitHealth.damageTaken / 5)
                                                  .floor() +
                                              (unit.unitHealth.damageTaken % 5),
                                          unit.unitHealth.damageTaken >= 50
                                              ? 1
                                              : 15), (index) {
                                    return Column(
                                      children: [
                                        Row(children: [
                                          if (unit.unitHealth.damageTaken < 50)
                                            Container(
                                              color: Colors.black,
                                              width: 30,
                                              height: (index >
                                                      (unit.unitHealth.damageTaken /
                                                                  5)
                                                              .floor() -
                                                          1)
                                                  ? 5
                                                  : 20,
                                            ),
                                          if (unit.unitHealth.damageTaken >= 50)
                                            Container(
                                              color: Colors.black,
                                              width: 30,
                                              height: 50,
                                              child: const RotatedBox(
                                                quarterTurns: 1,
                                                child: Text(
                                                  'DEAD',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          SizedBox(width: 3),
                                          if (index == 0)
                                            Text(unit.unitHealth.statuses
                                                    .contains(Status.dead)
                                                ? '***'
                                                : unit.unitHealth.statuses
                                                        .contains(Status.uncon)
                                                    ? '**'
                                                    : unit.unitHealth.statuses
                                                            .contains(
                                                                Status.stun)
                                                        ? '*'
                                                        : ''),
                                          if (unit.unitHealth.damageTaken >
                                                  20 &&
                                              index > 2 &&
                                              (index <=
                                                  (unit.unitHealth.damageTaken /
                                                              5)
                                                          .floor() -
                                                      1) &&
                                              index !=
                                                  (unit.unitHealth.damageTaken /
                                                              5)
                                                          .floor() +
                                                      (unit.unitHealth
                                                              .damageTaken %
                                                          5) -
                                                      1)
                                            Text('-${index - 2} all'),
                                        ]),
                                        SizedBox(height: 3),
                                      ],
                                    );
                                  }),
                                  // children: [

                                  //   Container(
                                  //     color: Colors.black,
                                  //     width: 30,
                                  //     height: 20,
                                  //   )
                                  // ],
                                ),
                              ]))),
                )
              ]),
            ),
            //bottom unit vvv
            Expanded(
              child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  width: screenWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (bottomWidget == 'battleStats')
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      StatblockState(
                                        updateParent: refreshUnit,
                                        unit: unit,
                                        stats: 'battleStats',
                                        bigKey: 'MA',
                                      ),
                                      StatblockState(
                                        updateParent: refreshUnit,
                                        unit: unit,
                                        stats: 'gunStats',
                                        prefix: 'gun',
                                        bigKey: 'Mod. WA',
                                        bigValue:
                                            '${objtoint(widget.unit.gunStats['gunWA']) + objtoint(widget.unit.battleStats['WS'])}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(children: [
                                Row(
                                  children: [
                                    ExpandedRectButton(
                                        'Stats', (() {}), bigButtonHeight,
                                        flexWeight: 1),
                                    ExpandedRectButton('Get Shot!', (() {
                                      setState(() {
                                        bottomWidget = 'random';
                                      });
                                    }), bigButtonHeight, flexWeight: 3),
                                  ],
                                )
                              ]),
                            ],
                          ),
                        ),
                      if (bottomWidget == 'random')
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                ExpandedRectButton('Roll Location', (() {
                                  setState(() {
                                    randomLocation();
                                  });
                                }), bigButtonHeight)
                              ]),
                              if (!rollDmg)
                                Row(
                                  children: [
                                    ExpandedRectButton(
                                        '0',
                                        selectedLocationIndex == -1
                                            ? null
                                            : (() {
                                                setState(() {
                                                  numOfDmg = 0;
                                                });
                                              }),
                                        smallButtonHeight),
                                    ExpandedRectButton(
                                        '--',
                                        selectedLocationIndex == -1
                                            ? null
                                            : (() {
                                                setState(() {
                                                  numOfDmg =
                                                      max(numOfDmg! - 5, 0);
                                                });
                                              }),
                                        smallButtonHeight),
                                    ExpandedRectButton(
                                        '-',
                                        selectedLocationIndex == -1
                                            ? null
                                            : (() {
                                                setState(() {
                                                  numOfDmg =
                                                      max(numOfDmg! - 1, 0);
                                                });
                                              }),
                                        smallButtonHeight),
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.all(0),
                                            minimumSize: Size(30, 30)),
                                        onPressed: (() {
                                          //hard enter value
                                        }),
                                        child: Text(
                                          '${numOfDmg}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: fontSize * 1.25),
                                        )),
                                    ExpandedRectButton(
                                        '+',
                                        selectedLocationIndex == -1
                                            ? null
                                            : (() {
                                                setState(() {
                                                  numOfDmg = numOfDmg! + 1;
                                                });
                                              }),
                                        smallButtonHeight),
                                    ExpandedRectButton(
                                        '++',
                                        selectedLocationIndex == -1
                                            ? null
                                            : (() {
                                                setState(() {
                                                  numOfDmg = numOfDmg! + 5;
                                                });
                                              }),
                                        smallButtonHeight),
                                    ExpandedRectButton(
                                        'R',
                                        selectedLocationIndex == -1
                                            ? null
                                            : (() {
                                                setState(() {
                                                  numOfDmg = 1;
                                                  rollDmg = true;
                                                });
                                              }),
                                        smallButtonHeight),
                                  ],
                                ),
                              if (rollDmg)
                                Column(children: [
                                  Row(
                                    children: [
                                      ExpandedRectButton(
                                          '1',
                                          selectedLocationIndex == -1
                                              ? null
                                              : (() {
                                                  setState(() {
                                                    numOfDmg = 1;
                                                  });
                                                }),
                                          smallButtonHeight),
                                      ExpandedRectButton(
                                          '-',
                                          selectedLocationIndex == -1
                                              ? null
                                              : (() {
                                                  setState(() {
                                                    numOfDmg =
                                                        max(numOfDmg! - 1, 1);
                                                  });
                                                }),
                                          smallButtonHeight),
                                      TextButton(
                                          onPressed: (() {
                                            if (dieType == 6) {
                                              setState(() {
                                                dieType = 10;
                                              });
                                            } else {
                                              setState(() {
                                                dieType = 6;
                                              });
                                            }
                                          }),
                                          child: Text(
                                            '${numOfDmg}D${dieType}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize * 1.25),
                                          )),
                                      ExpandedRectButton(
                                          '+',
                                          selectedLocationIndex == -1
                                              ? null
                                              : (() {
                                                  setState(() {
                                                    numOfDmg = numOfDmg! + 1;
                                                  });
                                                }),
                                          smallButtonHeight),
                                      ExpandedRectButton(
                                          'D',
                                          selectedLocationIndex == -1
                                              ? null
                                              : (() {
                                                  setState(() {
                                                    numOfDmg = 0;
                                                    rollDmg = false;
                                                  });
                                                }),
                                          smallButtonHeight),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      ExpandedRectButton(
                                          '-',
                                          selectedLocationIndex == -1
                                              ? null
                                              : (() {
                                                  setState(() {
                                                    bonusDmg =
                                                        max(bonusDmg! - 1, 0);
                                                  });
                                                }),
                                          smallButtonHeight),
                                      TextButton(
                                          onPressed: (() {
                                            if (dieType == 6) {
                                              setState(() {
                                                dieType = 10;
                                              });
                                            } else {
                                              setState(() {
                                                dieType = 6;
                                              });
                                            }
                                          }),
                                          child: Text(
                                            '+${bonusDmg}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize * 1.25),
                                          )),
                                      ExpandedRectButton(
                                          '+',
                                          selectedLocationIndex == -1
                                              ? null
                                              : (() {
                                                  setState(() {
                                                    bonusDmg = bonusDmg! + 1;
                                                  });
                                                }),
                                          smallButtonHeight),
                                    ],
                                  ),
                                ]),
                              Container(
                                  child: Row(children: [
                                ExpandedRectButton(
                                    'Deal Damage',
                                    numOfDmg == 0 || selectedLocationIndex == -1
                                        ? null
                                        : (() {
                                            dealDamage();
                                          }),
                                    bigButtonHeight)
                              ])),
                            ],
                          ),
                        ),
                      if (bottomWidget == 'report')
                        Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    // height: MediaQuery.sizeOf(context).height *
                                    //     0.43,
                                    child: SingleChildScrollView(
                                        child: Column(
                                  children: report.map((e) {
                                    return Text(e);
                                  }).toList(),
                                ))),
                                Container(
                                    height: bigButtonHeight,
                                    child: Row(
                                      children: [
                                        ExpandedRectButton('Back', (() {
                                          setState(() {
                                            resetData();
                                            bottomWidget = 'battleStats';
                                          });
                                        }), bigButtonHeight),
                                        ExpandedRectButton('Roll Again', (() {
                                          setState(() {
                                            bottomWidget = 'random';
                                            randomLocation();
                                          });
                                        }), bigButtonHeight)
                                      ],
                                    ))
                              ]),
                        )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> dealDamage() async {
    shotCount++;
    if (rollDmg == false) {
      report = [];
      if (shotCount > 1) {
        report.add('Shot ${shotCount}:');
      }
      report.addAll(widget.unit.unitHealth
          .dealDamage(numOfDmg, selectedLocationIndex, APType.Normal()));
      numOfDmg = 0;
    } else {
      if (shotCount == 1) {
        report = [];
      }
      List<String> tempReport = [];

      tempReport.add('Shot ${shotCount}:');
      int dmg = bonusDmg;
      for (var i = 0; i < numOfDmg; i++) {
        dmg += Random().nextInt(6) + 1;
      }
      dmg = max(dmg, 0);
      tempReport.add('Rolled ${dmg} damage');

      tempReport.addAll(widget.unit.unitHealth
          .dealDamage(dmg, selectedLocationIndex, APType.Normal()));

      report.insertAll(0, tempReport);
    }
    bottomWidget = 'report';
    await refreshUnit();
  }

  void randomLocation() async {
    for (int i = 0; i < 20; i++) {
      setState(() {
        selectedLocationIndex = rollLocation();
      });
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }
} //end UnitWidget
