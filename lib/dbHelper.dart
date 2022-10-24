// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'databaseClasses.dart';

class DBHelper {
  Future<Database> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = join(await getDatabasesPath(), "vbstats.db");
    // print(path);
    final database = openDatabase(
      path,
      onCreate: ((db, version) async {
        print("Creating Tables!");
        await db.execute(
            "CREATE TABLE players(id TEXT PRIMARY KEY, name TEXT, number INTEGER, position STRING, team STRING, serveAtt INTEGER, serveErr INTEGER, aces INTEGER, dig INTEGER, digErr INTEGER, pass INTEGER, passErr INTEGER, killAtt INTEGER, kill INTEGER, killErr INTEGER, assists INTEGER, assistsErr INTEGER, blockAtt INTEGER, block INTEGER, blockErr INTEGER); ");
        print("Created Player Table!");

        await db.execute(
            "CREATE TABLE gameStats(gameID TEXT, playerID INTEGER, serveAtt INTEGER, serveErr INTEGER, aces INTEGER, dig INTEGER, digErr INTEGER, pass INTEGER, passErr INTEGER, killAtt INTEGER, kill INTEGER, killErr INTEGER, assists INTEGER, assistsErr INTEGER, blockAtt INTEGER, block INTEGER, blockErr INTEGER); ");
        print("Created GameStats Table!");

        await db.execute("CREATE TABLE games(id TEXT, lineupId TEXT, teamName TEXT, oppName TEXT, date INTEGER, teamPoints INTEGER, oppPoints INTEGER); ");
        print("Created Games Table!");

        await db.execute("CREATE TABLE lineups(id TEXT, name TEXT PRIMARY KEY);");
        print("Created Roster Table!");

        await db.execute("CREATE TABLE lineupEntries(lineupID TEXT, playerID TEXT, rotation INTEGER );");
        print("Created Roster Entries Table!");

        return;
      }),
      version: 1,
    );
    return database;
  }

  String generateID() {
    var ranAssets = RanKeyAssets();
    String first4alphabets = '';
    String middle4Digits = '';
    String last4alphabets = '';
    for (int i = 0; i < 4; i++) {
      first4alphabets += ranAssets.smallAlphabets[Random.secure().nextInt(ranAssets.smallAlphabets.length)];

      middle4Digits += ranAssets.digits[Random.secure().nextInt(ranAssets.digits.length)];

      last4alphabets += ranAssets.smallAlphabets[Random.secure().nextInt(ranAssets.smallAlphabets.length)];
    }

    return '$first4alphabets-$middle4Digits-$last4alphabets';
  }

  Future<void> alterGameTable() async {
    final db = await initialize();
    // print("Saving new player");
    
    await db.execute("ALTER TABLE games ADD COLUMN teamName TEXT;");
    await db.execute("ALTER TABLE games ADD COLUMN oppName TEXT;");
  }

  Future<void> newPlayer(Player player) async {
    final db = await initialize();
    // print("Saving new player");
    await db.insert("players", player.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> newGameStats(GameStats gameStats) async {
    final db = await initialize();
    await db.insert("gameStats", gameStats.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateGameStats(GameStats gameStat, String statCol) async {
    final db = await initialize();
    await db.rawUpdate(
        "UPDATE gameStats SET $statCol = $statCol + 1 WHERE playerID = '${gameStat.playerID}' AND gameID = '${gameStat.gameID}';");
    // await db.insert("gameStats", gameStat.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> newGame(Game game) async {
    final db = await initialize();
    await db.insert("games", game.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> newLineupEntry(LineupEntry lineupEntry) async {
    final db = await initialize();
    await db.insert("lineupEntries", lineupEntry.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> newLineup(Lineup lineup) async {
    final db = await initialize();
    await db.insert("lineups", lineup.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Player>> getPlayers() async {
    final db = await initialize();
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM players");
    // print(maps);
    // int padLength = 10;
    return List.generate(maps.length, (i) {
      Player player = Player(
          id: maps[i]["id"],
          name: maps[i]["name"],
          number: maps[i]["number"],
          position: maps[i]["position"],
          team: maps[i]["team"],
          serveAtt: maps[i]["serveAtt"],
          serveErr: maps[i]["serveErr"],
          aces: maps[i]["aces"],
          dig: maps[i]["dig"],
          digErr: maps[i]["digErr"],
          pass: maps[i]["pass"],
          passErr: maps[i]["passErr"],
          killAtt: maps[i]["killAtt"],
          kill: maps[i]["kill"],
          killErr: maps[i]["killErr"],
          assists: maps[i]["assists"],
          assistErr: maps[i]["assistsErr"],
          blockAtt: maps[i]["blockAtt"],
          block: maps[i]["block"],
          blockErr: maps[i]["blockErr"]);
      return player;
    });
  }

  Future<Player> getPlayer(String id) async {
    final db = await initialize();
    final List<Map<String, dynamic>> maps = await db.query('players', where: "id = ?", whereArgs: [id]);
    List playerList = List.generate(maps.length, (i) {
      return Player(
          id: maps[i]["id"],
          name: maps[i]["name"],
          number: maps[i]["number"],
          position: maps[i]["position"],
          team: maps[i]["team"],
          serveAtt: maps[i]["serveAtt"],
          serveErr: maps[i]["serveErr"],
          aces: maps[i]["aces"],
          dig: maps[i]["dig"],
          digErr: maps[i]["digErr"],
          pass: maps[i]["pass"],
          passErr: maps[i]["passErr"],
          killAtt: maps[i]["killAtt"],
          kill: maps[i]["kill"],
          killErr: maps[i]["killErr"],
          assists: maps[i]["assists"],
          assistErr: maps[i]["assistsErr"],
          blockAtt: maps[i]["blockAtt"],
          block: maps[i]["block"],
          blockErr: maps[i]["blockErr"]);
    });
    return playerList[0];
  }

  Future<List<GameStats>> getGameStats(String gameID, String orderBy) async {
    final db = await initialize();
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM gameStats WHERE gameID = '$gameID' ORDER by $orderBy DESC");
    return List.generate(maps.length, (i) {
      return GameStats(
          gameID: maps[i]["gameID"],
          playerID: maps[i]["playerID"],
          serveAtt: maps[i]["serveAtt"],
          serveErr: maps[i]["serveErr"],
          aces: maps[i]["aces"],
          dig: maps[i]["dig"],
          digErr: maps[i]["digErr"],
          pass: maps[i]["pass"],
          passErr: maps[i]["passErr"],
          killAtt: maps[i]["killAtt"],
          kill: maps[i]["kill"],
          killErr: maps[i]["killErr"],
          assists: maps[i]["assists"],
          assistErr: maps[i]["assistsErr"],
          blockAtt: maps[i]["blockAtt"],
          block: maps[i]["block"],
          blockErr: maps[i]["blockErr"]);
    });
  }

  Future<List<Game>> getGames() async {
    final db = await initialize();
    final List<Map<String, dynamic>> maps = await db.query("games");
    return List.generate(maps.length, (i) {
      return Game(
        id: maps[i]["id"],
        lineupId: maps[i]["lineupId"],
        teamName: maps[i]["teamName"],
        oppName: maps[i]["oppName"],
        date: maps[i]["date"],
        teamPoints: maps[i]["teamPoints"],
        oppPoints: maps[i]["oppPoints"],
      );
    });
  }

  Future<List<Player>> getLineupPlayers(String lineupID) async {
    final db = await initialize();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM lineupEntries INNER JOIN players ON lineupEntries.playerID = players.id WHERE lineupEntries.lineupID = \"$lineupID\" ORDER BY rotation ASC");

    return List.generate(maps.length, (i) {
      return Player(
          id: maps[i]["id"],
          name: maps[i]["name"],
          number: maps[i]["number"],
          position: maps[i]["position"],
          team: maps[i]["team"],
          serveAtt: maps[i]["serveAtt"],
          serveErr: maps[i]["serveErr"],
          aces: maps[i]["aces"],
          dig: maps[i]["dig"],
          digErr: maps[i]["digErr"],
          pass: maps[i]["pass"],
          passErr: maps[i]["passErr"],
          killAtt: maps[i]["killAtt"],
          kill: maps[i]["kill"],
          killErr: maps[i]["killErr"],
          assists: maps[i]["assists"],
          assistErr: maps[i]["assistsErr"],
          blockAtt: maps[i]["blockAtt"],
          block: maps[i]["block"],
          blockErr: maps[i]["blockErr"]);
    });
    // final List<Map<String, dynamic>> maps = await db.rawQuery(
    //     "SELECT * from rosters WHERE playerID IN (SELECT MIN(playerID) FROM rosters GROUP BY name);");
    // return List.generate(maps.length, (i) {
    //   return RosterEntry(
    //       rosterID: maps[i]["id"],
    //       playerID: maps[i]["playerID"]);
    // });
  }

  Future<List<Lineup>> getLineups() async {
    final db = await initialize();
    final List<Map<String, dynamic>> maps = await db.query("lineups");
    return List.generate(maps.length, (i) {
      return Lineup(id: maps[i]["id"], name: maps[i]["name"]);
    });
  }

  Future<Lineup> getLineup(String id) async {
    final db = await initialize();
    final List<Map<String, dynamic>> maps = await db.query("lineups", where: "id = ?", whereArgs: [id]);
    return List.generate(maps.length, (i) {
      return Lineup(id: maps[i]["id"], name: maps[i]["name"]);
    })[0];
  }

  Future<void> deletePlayer(String id) async {
    print("Deleting $id");
    final db = await initialize();
    await db.delete('players', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteLineup(String id) async {
    final db = await initialize();
    await db.delete('lineups', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteLineupEntry(String lineupID, String playerID) async {
    final db = await initialize();
    await db.delete('lineupEntries', where: '(lineupID = ? AND playerID = ?) ', whereArgs: [lineupID, playerID]);
  }

  Future<void> deleteGameStats(String id) async {
    final db = await initialize();
    await db.delete('gameStats', where: 'gameID = ?', whereArgs: [id]);
  }

  Future<void> deleteGame(String id) async {
    final db = await initialize();
    await db.delete('games', where: 'id = ?', whereArgs: [id]);
  }
}

class RanKeyAssets {
  var smallAlphabets = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];
  var digits = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];
}
