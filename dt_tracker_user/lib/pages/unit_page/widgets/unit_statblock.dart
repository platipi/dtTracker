import 'package:dt_tracker_user/pages/unit_page/widgets/change_stat.dart';
import 'package:dt_tracker_user/utilities/data/unit.dart';
import 'package:dt_tracker_user/utilities/globals.dart';
import 'package:flutter/material.dart';

class StatblockState extends StatefulWidget {
  Unit unit;
  String stats;
  final String? prefix;
  final String? bigKey;
  String? bigValue;
  Function updateParent;
  StatblockState({
    required this.unit,
    required this.stats,
    required this.updateParent,
    this.prefix,
    this.bigKey,
    this.bigValue,
  });

  StatblockWidget createState() => StatblockWidget(
      unit: unit,
      stats: stats,
      prefix: prefix,
      bigKey: bigKey,
      bigValue: bigValue); //bad code, change to widget.value
}

class StatblockWidget extends State<StatblockState> {
  final String stats;
  final String? prefix;
  final String? bigKey;
  String? bigValue;
  Unit unit;

  StatblockWidget(
      {required this.unit,
      required this.stats,
      this.prefix,
      this.bigKey,
      this.bigValue});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> getUnitMap() {
      if (stats == 'battleStats') {
        return unit.battleStats;
      } else if (stats == 'gunStats') {
        return unit.gunStats;
      } else if (stats == 'floofStats') {
        return unit.floofStats;
      }
      return {};
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (bigKey != null)
            GestureDetector(
              onTap: (() {
                if (bigValue == null) {
                  AlertChangeStat(
                      context: context,
                      title: 'Change ${bigKey}',
                      unit: unit,
                      statKey: bigKey!,
                      updateParent: widget.updateParent);
                } else {
                  ScaffoldMessenger.of(context!).showSnackBar(
                    SnackBar(
                        content: Text('Unable to change calculated fields'),
                        duration: Duration(milliseconds: 2500)),
                  );
                }
              }),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0, color: Colors.black),
                      color: Colors.black,
                    ),
                    child: Text(
                      prefix == null
                          ? bigKey!
                          : bigKey!.replaceAll(prefix!, ''),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontSize: fontSize * 1.2),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: fontSize * 2.3 + 18,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(width: 2.0, color: Colors.black),
                    ),
                    alignment: AlignmentDirectional(0.00, 0.00),
                    child: Text(
                      bigValue ?? getUnitMap()[bigKey],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black, fontSize: fontSize * 1.2),
                    ),
                  )
                ],
              ),
            ),
          SizedBox(width: 3),
          Expanded(
            child: Wrap(
              spacing: 0,
              runSpacing: 3,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.start,
              direction: Axis.horizontal,
              runAlignment: WrapAlignment.start,
              verticalDirection: VerticalDirection.down,
              clipBehavior: Clip.none,
              children: getUnitMap().entries.map((e) {
                return GestureDetector(
                    onTap: (() {
                      AlertChangeStat(
                          context: context,
                          title: 'Change ${e.key}',
                          unit: unit,
                          statKey: e.key,
                          updateParent: widget.updateParent);
                    }),
                    child: Wrap(
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        // if vvv causing an empty child on fail, leading to weird spacing on first item
                        if (bigKey != e.key)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2.0, color: Colors.black),
                              color: Colors.black,
                            ),
                            child: Text(
                              prefix == null
                                  ? e.key
                                  : e.key.replaceAll(prefix!, ''),
                              style: TextStyle(
                                  color: Colors.white, fontSize: fontSize),
                            ),
                            //height: 33,
                          ),
                        if (bigKey != e.key)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              e.value.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: fontSize),
                            ),
                          ),
                      ],
                    ));
              }).toList(),
              //getUnitMap().map((e,a) {
              //   return Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       if (bigKey != e.key)
              //         Container(
              //           padding: EdgeInsets.symmetric(horizontal: 5),
              //           decoration: BoxDecoration(
              //             border: Border.all(width: 2.0, color: Colors.black),
              //             color: Colors.black,
              //           ),
              //           child: Text(
              //             prefix == null
              //                 ? e.key
              //                 : e.key.replaceAll(prefix!, ''),
              //             style: TextStyle(
              //                 color: Colors.white, fontSize: fontSize),
              //           ),
              //           //height: 33,
              //         ),
              //       if (bigKey != e.key)
              //         Container(
              //           padding: EdgeInsets.symmetric(horizontal: 5),
              //           child: Text(
              //             e.value.toString(),
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //                 color: Colors.black, fontSize: fontSize),
              //           ),
              //         ),
              //     ],
              //   );
              // }).toList()
            ),
          ),
        ],
      ),
    );
  }
}
