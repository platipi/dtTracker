import 'package:dt_tracker_user/pages/widgets/statblock.dart';
import 'package:dt_tracker_user/utilities/data/data_types.dart';
import 'package:dt_tracker_user/utilities/data/unit.dart';
import 'package:flutter/material.dart';

class UnitWidget extends StatelessWidget {
  final Unit unit;
  const UnitWidget({super.key, required this.unit});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.33,
              child: const Align(
                alignment: AlignmentDirectional(0.00, 0.00),
                child: Text(
                  'Unit',
                ),
              ),
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
