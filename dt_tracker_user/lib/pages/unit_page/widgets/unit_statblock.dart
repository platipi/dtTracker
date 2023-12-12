import 'package:dt_tracker_user/utilities/globals.dart';
import 'package:flutter/material.dart';

class Statblock extends StatelessWidget {
  final Map<String, dynamic> stats;
  final String? prefix;
  final String? bigKey;
  String? bigValue;

  Statblock(
      {super.key,
      required this.stats,
      this.prefix,
      this.bigKey,
      this.bigValue});

  void initState() {
    if (bigKey != null) {
      if (stats.containsKey(bigKey)) {
        bigValue = stats[bigKey];
        stats.remove(bigKey);
      } else {
        bigValue ??= 'hur';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initState();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (bigKey != null)
            Column(
              children: [
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, color: Colors.black),
                    color: Colors.black,
                  ),
                  child: Text(
                    prefix == null ? bigKey! : bigKey!.replaceAll(prefix!, ''),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontSize: fontSize * 1.2),
                  ),
                ),
                Container(
                  width: 100,
                  height: fontSize * 2.3 + 18,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, color: Colors.black),
                  ),
                  alignment: AlignmentDirectional(0.00, 0.00),
                  child: Text(
                    bigValue!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black, fontSize: fontSize * 1.2),
                  ),
                )
              ],
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
                children: stats.entries.map((e) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (bigKey != e.key)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2.0, color: Colors.black),
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
                            e.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black, fontSize: fontSize),
                          ),
                        ),
                    ],
                  );
                }).toList()),
          ),
        ],
      ),
    );
  }
}
