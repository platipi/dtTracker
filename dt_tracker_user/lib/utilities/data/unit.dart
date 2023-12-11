import 'package:dt_tracker_user/utilities/data/unit_health.dart';

class Unit {
  String name = 'Unamed Unit';
  UnitHealth unitHealth = UnitHealth.empty();
  Map<String, dynamic> battleStats = {
    'MA': '6',
    'Dodge': '9',
    'Endurance': '9',
    'Ref': '6',
    'WS': '9',
    'Utility': 'a'
  };
  Map<String, dynamic> gunStats = {
    'gunName': 'A Longer Value',
    'gunDamage': '0',
    'gunRange': '0',
    'gunROF': '0',
    'gunMagazine': '0',
    'gunWA': '0',
    'gunNotes': 'Some other long value'
  };
  Map<String, dynamic> floofStats = {
    'aSkill': '5',
    'Notes': '',
  };

  Map<String, dynamic> getBattleStats() {
    Map<String, dynamic> returnList = {};
    returnList.addEntries(battleStats.entries);
    returnList['Body'] = unitHealth.body.toString();
    returnList.remove('Utility');
    returnList['Utility'] = battleStats['Utility']!;
    return returnList;
  }

  Unit.simple(this.name, this.unitHealth);
  Unit(this.name, this.unitHealth, this.battleStats, this.gunStats,
      this.floofStats);

  factory Unit.fromJson(dynamic json) {
    return Unit(
        json['name'] as String,
        UnitHealth.fromJson(json['unitHealth']),
        json['battleStats'] as Map<String, dynamic>,
        json['gunStats'] as Map<String, dynamic>,
        json['floofStats'] as Map<String, dynamic>);
  }

  Map toJson() {
    Map unitHealth = this.unitHealth.toJson();
    return {
      'name': name,
      'unitHealth': unitHealth,
      'battleStats': battleStats,
      'gunStats': gunStats,
      'floofStats': floofStats
    };
  }
}
