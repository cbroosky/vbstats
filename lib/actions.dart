import 'package:vbstat/dbHelper.dart';

class StatAction {
  final String name;
  final String column;
  final bool affectsScore;

  StatAction(
      {required this.name, required this.column, required this.affectsScore});

  void doAction(String playerID) {
    // dbHelper().addStat(playerID, column);
  }
}
