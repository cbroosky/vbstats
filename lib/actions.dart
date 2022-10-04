class StatAction {
  final String name;
  final String column;
  final int scoreAdjustment;

  StatAction({required this.name, required this.column, required this.scoreAdjustment});
}

class PlayerStat {
  final String playerID;
  final StatAction statAction;

  PlayerStat({required this.playerID, required this.statAction});

  void doAction() {
    // TODO Add action code
    // dbHelper().addStat(playerID, column);
  }
}
