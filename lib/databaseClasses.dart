// ignore_for_file: file_names

class Player {
  final String id;
  final String name;
  int number;
  String position;
  String team;

  int serveAtt;
  int aces;
  int serveErr;

  int pass;
  int passErr;

  int dig;
  int digErr;

  int killAtt;
  int kill;
  int killErr;

  int assists;
  int assistErr;

  int blockAtt;
  int block;
  int blockErr;

  Player(
      {required this.id,
      required this.name,
      required this.number,
      required this.position,
      required this.team,
      this.serveAtt = 0,
      this.serveErr = 0,
      this.aces = 0,
      this.pass = 0,
      this.passErr = 0,
      this.dig = 0,
      this.digErr = 0,
      this.killAtt = 0,
      this.kill = 0,
      this.killErr = 0,
      this.assists = 0,
      this.assistErr = 0,
      this.blockAtt = 0,
      this.block = 0,
      this.blockErr = 0});

  @override
  String toString() {
    return """ID: $id,
    Name: $name,
    Number: $number,
    Position: $position,
    Team: $team,
    Serve Attempts: $serveAtt,
    Serve Errors: $serveErr,
    Aces: $aces,
    Digs: $dig,
    Dig Errors: $digErr,
    Passes: $pass,
    Pass Errors: $passErr,
    Kill Attempts: $killAtt,
    Kills: $kill,
    Kill Errors: $killErr,
    Assists: $assists,
    Assist Errors: $assistErr,
    Block Attempts: $blockAtt,
    Blocks: $block,
    Block Errors: $blockErr
    """;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'position': position,
      'team': team,
      'serveAtt': serveAtt,
      'serveErr': serveErr,
      'aces': aces,
      'dig': dig,
      'digErr': digErr,
      'pass': pass,
      'passErr': passErr,
      'killAtt': killAtt,
      'kill': kill,
      'killErr': killErr,
      'assists': assists,
      'assistsErr': assistErr,
      'blockAtt': blockAtt,
      'block': block,
      'blockErr': blockErr
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

  const LineupEntry({required this.lineupID, required this.playerID, required this.rotation});

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
  int serveAtt;
  int aces;
  int serveErr;

  int pass;
  int passErr;

  int dig;
  int digErr;

  int killAtt;
  int kill;
  int killErr;

  int assists;
  int assistErr;

  int blockAtt;
  int block;
  int blockErr;

  GameStats(
      {required this.gameID,
      required this.playerID,
      this.serveAtt = 0,
      this.serveErr = 0,
      this.aces = 0,
      this.pass = 0,
      this.passErr = 0,
      this.dig = 0,
      this.digErr = 0,
      this.killAtt = 0,
      this.kill = 0,
      this.killErr = 0,
      this.assists = 0,
      this.assistErr = 0,
      this.blockAtt = 0,
      this.block = 0,
      this.blockErr = 0});

  Map<String, dynamic> toMap() {
    return {
      'playerID': playerID,
      'serveAtt': serveAtt,
      'serveErr': serveErr,
      'aces': aces,
      'dig': dig,
      'digErr': digErr,
      'pass': pass,
      'passErr': passErr,
      'killAtt': killAtt,
      'kill': kill,
      'killErr': killErr,
      'assists': assists,
      'assistsErr': assistErr,
      'blockAtt': blockAtt,
      'block': block,
      'blockErr': blockErr
    };
  }
}

class Game {
  final String id;
  final String name;
  final int date;
  final int teamPoints;
  final int oppPoints;

  Game({required this.id, required this.name, required this.date, this.teamPoints = 0, this.oppPoints = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'teamPoints': teamPoints,
      'oppPoints': oppPoints,
    };
  }
}
