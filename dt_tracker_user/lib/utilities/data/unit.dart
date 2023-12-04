import 'package:dt_tracker_user/utilities/data/unit_health.dart';

class Unit {
  String name = 'Unamed';
  UnitHealth unitHealth = UnitHealth();
  var battleStats = {
    'MA': '6',
    'Dodge': '9',
    'Endurance': '9',
    'Ref': '6',
    'WS': '9',
    'Utility': 'a'
  };
  var gunStats = {
    'gunName': 'A Longer Value',
    'gunDamage': '0',
    'gunRange': '0',
    'gunROF': '0',
    'gunMagazine': '0',
    'gunWA': '0',
    'gunNotes': 'Some other long value'
  };
  var floofStats = {
    'aSkill': '5',
    'Notes': '',
  };

  Map<String, String> getBattleStats() {
    Map<String, String> returnList = {};
    returnList.addEntries(battleStats.entries);
    returnList['Body'] = unitHealth.body.toString();
    returnList.remove('Utility');
    returnList['Utility'] = battleStats['Utility']!;
    return returnList;
  }
}
