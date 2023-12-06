import 'package:dt_tracker_user/pages/widgets/statblock.dart';
import 'package:dt_tracker_user/utilities/data/data_functions.dart';
import 'package:dt_tracker_user/utilities/data/unit.dart';
import 'package:dt_tracker_user/utilities/globals.dart';
import 'package:flutter/material.dart';

class UnitWidget extends StatelessWidget {
  final Unit unit;
  const UnitWidget({super.key, required this.unit});

  Color? getColor(int location) {
    print('location: ${location}');
    if (location < 0 || location > 5) {
      return null;
    }
    int maxSP = unit.unitHealth.armor[location].maxSp;
    int curSP = unit.unitHealth.armor[location].curSp;
    print('sp: ${curSP}/${maxSP}');
    if (curSP == maxSP) {
      return null;
    } else {
      print('color: ${location}');
      return getColorFromDamage(curSP / maxSP);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
      0: AlignmentDirectional(0.21, -1.03), //head
      1: AlignmentDirectional(-0.02, -0.4), //torso
      2: AlignmentDirectional(-0.35, -0.53), //larm
      3: AlignmentDirectional(0.35, -0.62), //rarm
      4: AlignmentDirectional(-0.33, 0.25), //lleg
      5: AlignmentDirectional(0.35, 0.32), //rleg
    };
    return Center(
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.33,
              child: Stack(children: [
                Stack(
                    children: imgLinks.entries.map((e) {
                  return Image(
                    image: AssetImage(e.value),
                    width: screenWidth,
                    color: getColor(e.key),
                    fit: BoxFit.fitHeight,
                  );
                }).toList()), //images
                Stack(
                    children: spPos.entries.map((e) {
                  return Align(
                    alignment: e.value,
                    child: Text(unit.unitHealth.armor[e.key].curSp.toString(),
                        style: TextStyle(
                          color: e.key == 1 && getColor(1) != Colors.yellow
                              ? Colors.white
                              : Colors.black,
                          fontSize: fontSize,
                        )),
                  );
                }).toList()), //sp values
                Align(
                    alignment: AlignmentDirectional(-0.95, 0.95),
                    child: Container(
                      color: Colors.white,
                      child: Text(
                        unit.name,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: fontSize * 1.4,
                        ),
                      ),
                    )) //name
              ]),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.5,
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
          ],
        ),
      ),
    );
  }
}
