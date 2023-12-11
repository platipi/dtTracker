import 'dart:math';

import 'package:dt_tracker_user/pages/widgets/change_sp.dart';
import 'package:dt_tracker_user/pages/widgets/shot_button.dart';
import 'package:dt_tracker_user/pages/widgets/unit_statblock.dart';
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
  const UnitState({super.key, required this.unit});

  @override
  UnitWidget createState() => UnitWidget();
}

class UnitWidget extends State<UnitState> {
  //const UnitWidget({super.key, required this.unit});
  String bottomWidget = 'battleStats';
  int numOfDmg = 0;
  int bonusDmg = 0;
  int dieType = 6;
  bool rollDmg = false;
  late Function refreshUnit;
  List<String> report = [];

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
      saveData();
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
    var spPos = {
      0: const AlignmentDirectional(0.23, -1.18), //head
      1: const AlignmentDirectional(-0.02, -0.45), //torso
      2: const AlignmentDirectional(-0.39, -0.6), //larm
      3: const AlignmentDirectional(0.39, -0.71), //rarm
      4: const AlignmentDirectional(-0.36, 0.29), //lleg
      5: const AlignmentDirectional(0.39, 0.37), //rleg
    };

    return Center(
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(
              height: 50,
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
                  return Align(
                      alignment: e.value,
                      child: GestureDetector(
                          onTap: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return changeSpWidget(unit, e.key, refreshUnit);
                              }),
                          child: Container(
                            color: Colors.transparent,
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                                unit.unitHealth.armor[e.key].curSp.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: e.key == 1 &&
                                          getColor(unit, 1) != Colors.yellow
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: fontSize,
                                )),
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
                                  return changeSpWidget(unit, 10, refreshUnit);
                                });
                          },
                          child: Icon(CupertinoIcons.textformat_123),
                        ),
                      ],
                    )) //end Unit type cycle
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
                              Column(
                                children: [
                                  Statblock(
                                    stats: widget.unit.getBattleStats(),
                                    bigKey: 'MA',
                                  ),
                                  Statblock(
                                    stats: widget.unit.gunStats,
                                    prefix: 'gun',
                                    bigKey: 'Mod. WA',
                                    bigValue:
                                        '${objtoint(widget.unit.gunStats['gunWA']) + objtoint(widget.unit.battleStats['WS'])}',
                                  ),
                                ],
                              ),
                              Column(children: [
                                Row(
                                  children: [
                                    RectButton('Single Shot', (() {})),
                                    RectButton('Random Shot(s)', (() {
                                      setState(() {
                                        bottomWidget = 'randomShot';
                                      });
                                    })),
                                  ],
                                )
                              ]),
                            ],
                          ),
                        ),
                      if (bottomWidget == 'randomShot')
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  height: 80,
                                  child: Row(children: [
                                    RectButton('Roll Location', (() {
                                      setState(() {
                                        randomLocation();
                                      });
                                    }))
                                  ])),
                              if (!rollDmg)
                                Row(
                                  children: [
                                    RectButton('0', (() {
                                      setState(() {
                                        numOfDmg = 0;
                                      });
                                    })),
                                    RectButton('--', (() {
                                      setState(() {
                                        numOfDmg = max(numOfDmg! - 5, 0);
                                      });
                                    })),
                                    RectButton('-', (() {
                                      setState(() {
                                        numOfDmg = max(numOfDmg! - 1, 0);
                                      });
                                    })),
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
                                    RectButton('+', (() {
                                      setState(() {
                                        numOfDmg = numOfDmg! + 1;
                                      });
                                    })),
                                    RectButton('++', (() {
                                      setState(() {
                                        numOfDmg = numOfDmg! + 5;
                                      });
                                    })),
                                    RectButton('R', (() {
                                      setState(() {
                                        numOfDmg = 1;
                                        rollDmg = true;
                                      });
                                    })),
                                  ],
                                ),
                              if (rollDmg)
                                Column(children: [
                                  Row(
                                    children: [
                                      RectButton('1', (() {
                                        setState(() {
                                          numOfDmg = 1;
                                        });
                                      })),
                                      RectButton('-', (() {
                                        setState(() {
                                          numOfDmg = max(numOfDmg! - 1, 1);
                                        });
                                      })),
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
                                      RectButton('+', (() {
                                        setState(() {
                                          numOfDmg = numOfDmg! + 1;
                                        });
                                      })),
                                      RectButton('D', (() {
                                        setState(() {
                                          numOfDmg = 0;
                                          rollDmg = false;
                                        });
                                      })),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      RectButton('-', (() {
                                        setState(() {
                                          bonusDmg = max(bonusDmg! - 1, 0);
                                        });
                                      })),
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
                                      RectButton('+', (() {
                                        setState(() {
                                          bonusDmg = bonusDmg! + 1;
                                        });
                                      })),
                                    ],
                                  ),
                                ]),
                              Container(
                                  height: 80,
                                  child: Row(children: [
                                    RectButton('Deal Damage', (() {
                                      setState(() {
                                        report = unit.unitHealth.dealDamage(
                                            numOfDmg,
                                            selectedLocationIndex,
                                            APType.Normal());
                                      });
                                      refreshUnit();
                                      bottomWidget = 'afterActionReport';
                                    }))
                                  ])),
                            ],
                          ),
                        ),
                      if (bottomWidget == 'afterActionReport')
                        Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: report.map((e) {
                                    return Text(e);
                                  }).toList(),
                                ),
                                Container(
                                    height: 80,
                                    child: Row(
                                      children: [
                                        RectButton('Back', (() {
                                          setState(() {
                                            bottomWidget = 'battleStats';
                                          });
                                        })),
                                        RectButton('Roll Again', (() {
                                          setState(() {
                                            if (!rollDmg) {
                                              bottomWidget = 'randomShot';
                                              randomLocation();
                                            }
                                          });
                                        }))
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
    if (rollDmg == false) {
      print('da dmg' +
          widget.unit.unitHealth
              .dealDamage(numOfDmg, selectedLocationIndex, APType.Normal())
              .toString());
    }
    await Future.delayed(const Duration(milliseconds: 10));
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
