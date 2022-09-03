// ignore_for_file: file_names

class Player {
  final String id;
  final String name;
  int number;
  String position;
  String team;
  int goodServes;
  int badServes;
  int aces;
  int assists;
  int spikes;
  int tips;
  int digs;

  Player({
    required this.id,
    required this.name,
    required this.number,
    required this.position,
    required this.team,
    this.goodServes = 0,
    this.badServes = 0,
    this.aces = 0,
    this.assists = 0,
    this.spikes = 0,
    this.tips = 0,
    this.digs = 0,
  });

  @override
  String toString() {
    return "ID: $id, \nName: $name, \nNumber: $number, \nPosition: $position, \nTeam: $team, \nGoodServes: $goodServes, \nBadServes: $badServes, \nAces: $aces, \nAssists: $assists, \nSpikes: $spikes, \nTips: $tips, \nDigs: $digs";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'position': position,
      'team': team,
      'goodServes': goodServes,
      'badServes': badServes,
      'aces': aces,
      'assists': assists,
      'spikes': spikes,
      'tips': tips,
      'digs': digs
    };
  }
}

class Lineup {
  String id;
  final String name;
  Lineup({required this.id, required this.name});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
  @override
  String toString() {
    return "ID: $id, \nName: $name";
  }
}

class LineupEntry {
  final String lineupID;
  final String playerID;
  final int rotation;

  const LineupEntry(
      {required this.lineupID, required this.playerID, required this.rotation});

  Map<String, dynamic> toMap() {
    return {
      'lineupID': lineupID,
      'playerID': playerID,
      'rotation': rotation,
    };
  }
  
}

class GameStats {
  final String gameID;
  final String playerID;
  final String name;
  int teamPoints;
  int oppPoints;
  int goodServes;
  int badServes;
  int aces;
  int assists;
  int spikes;
  int tips;
  int digs;

  GameStats(
      {required this.gameID,
      required this.playerID,
      required this.name,
      required this.teamPoints,
      required this.oppPoints,
      this.goodServes = 0,
      this.badServes = 0,
      this.aces = 0,
      this.assists = 0,
      this.spikes = 0,
      this.tips = 0,
      this.digs = 0});

  Map<String, dynamic> toMap() {
    return {
      'playerID': playerID,
      'name': name,
      'teamPoints': teamPoints,
      'oppPoints': oppPoints,
      'goodServes': goodServes,
      'badServes': badServes,
      'aces': aces,
      'assists': assists,
      'spikes': spikes,
      'tips': tips,
      'digs': digs
    };
  }
}
