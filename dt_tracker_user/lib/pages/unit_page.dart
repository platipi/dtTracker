import 'package:dt_tracker_user/pages/widgets/unit_statblock.dart';
import 'package:dt_tracker_user/utilities/data/data_functions.dart';
import 'package:dt_tracker_user/utilities/data/data_types.dart';
import 'package:dt_tracker_user/utilities/data/unit.dart';
import 'package:dt_tracker_user/utilities/globals.dart';
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

  Color? getColor(int location) {
    if (location < 0 || location > 5) {
      return null;
    }
    int maxSP = widget.unit.unitHealth.armor[location].maxSp;
    int curSP = widget.unit.unitHealth.armor[location].curSp;
    if (curSP == maxSP) {
      return null;
    } else {
      return getColorFromDamage(curSP / maxSP);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Unit unit = widget.unit;
    double screenWidth = 450;

    void refreshUnit() {
      setState(() {});
    }

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
            SizedBox(
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
                    color: getColor(e.key),
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
                                return changeSpWidget(e.key, refreshUnit);
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
                                  color:
                                      e.key == 1 && getColor(1) != Colors.yellow
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
                //unit type cycling vvv
                Align(
                  alignment: const AlignmentDirectional(1, -1),
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        iconSize: MaterialStateProperty.all(32),
                        iconColor: MaterialStateProperty.all(Colors.black),
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.black,
                              width: 3.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(0),
                          ),
                        ))),
                    onPressed: () {
                      cycleUnitType();
                    },
                    child: Icon(unit.unitHealth.unitType == UnitType.mook
                        ? CupertinoIcons.chevron_compact_down
                        : unit.unitHealth.unitType == UnitType.wildcard
                            ? CupertinoIcons.chevron_compact_up
                            : CupertinoIcons.minus),
                  ),
                ) //end Unit type cycle
              ]),
            ),
            //stats vvv
            Expanded(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.5,
                width: screenWidth,
                child: Column(
                  children: [
                    Statblock(
                      stats: unit.getBattleStats(),
                      bigKey: 'MA',
                    ),
                    Statblock(
                      stats: unit.gunStats,
                      prefix: 'gun',
                      bigKey: 'Mod. WA',
                      bigValue:
                          '${objtoint(unit.gunStats['gunWA']) + objtoint(unit.battleStats['WS'])}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } //end build context

  Widget changeSpWidget(int location, Function refreshParent) {
    String spValue = '';

    int validateSp(String value) {
      if (int.tryParse(spValue) != null) {
        return int.tryParse(spValue)!;
      }
      return -1;
    }

    void setSp(bool updateMax) {
      if (updateMax) {
        widget.unit.unitHealth.armor[location].maxSp = validateSp(spValue);
      }
      widget.unit.unitHealth.armor[location].curSp = validateSp(spValue);
      refreshParent();
      Navigator.pop(context);
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
          if (validateSp(spValue) >= 0)
            TextButton(
              onPressed: () {
                setSp(false);
              },
              child: const Text('Set Current'),
            ),
          if (validateSp(spValue) >= 0)
            TextButton(
              onPressed: () {
                setSp(true);
              },
              child: const Text('Set Max'),
            ),
        ],
      );
    });
  }
}//end UnitWidget
