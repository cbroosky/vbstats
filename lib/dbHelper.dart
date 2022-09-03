import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'databaseClasses.dart';

class dbHelper {
  Future<Database> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = join(await getDatabasesPath(), "vbstats.db");
    // print(path);
    final database = openDatabase(
      path,
      onCreate: ((db, version) async {
        print("Creating Tables!");
        await db.execute(
            "CREATE TABLE players(id TEXT, name TEXT PRIMARY KEY, number INTEGER, position STRING, team STRING, goodServes INTEGER, badServes INTEGER, aces INTEGER, assists INTEGER, spikes INTEGER, tips INTEGER, digs INTEGER); ");
        print("Created Player Table!");

        await db.execute(
            "CREATE TABLE gameStats(gameID TEXT PRIMARY KEY, name TEXT, teamPoints INTEGER, oppPoints INTEGER, playerID INTEGER, playerNumber INTEGER, position STRING, goodServes INTEGER, badServes INTEGER, aces INTEGER, assists INTEGER, spikes INTEGER, tips INTEGER, digs INTEGER); ");
        print("Created GameStats Table!");

        await db
            .execute("CREATE TABLE lineups(id TEXT, name TEXT PRIMARY KEY);");
        print("Created Roster Table!");

        await db.execute(
            "CREATE TABLE lineupEntries(lineupID TEXT, playerID TEXT, rotation INTEGER );");
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
      first4alphabets += ranAssets.smallAlphabets[
          Random.secure().nextInt(ranAssets.smallAlphabets.length)];

      middle4Digits +=
          ranAssets.digits[Random.secure().nextInt(ranAssets.digits.length)];

      last4alphabets += ranAssets.smallAlphabets[
          Random.secure().nextInt(ranAssets.smallAlphabets.length)];
    }

    return '$first4alphabets-$middle4Digits-$last4alphabets';
  }

  Future<void> newPlayer(Player player) async {
    final db = await initialize();
    await db.insert("players", player.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> newGameStats(GameStats gameStats) async {
    final db = await initialize();
    await db.insert("gameStats", gameStats.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> newLineupEntry(LineupEntry lineupEntry) async {
    final db = await initialize();
    await db.insert("lineupEntries", lineupEntry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> newLineup(Lineup lineup) async {
    final db = await initialize();
    await db.insert("lineups", lineup.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Player>> getPlayers() async {
    final db = await initialize();
    final List<Map<String, dynamic>> maps = await db.query("players");
    return List.generate(maps.length, (i) {
      return Player(
          id: maps[i]["id"],
          name: maps[i]["name"],
          number: maps[i]["number"],
          position: maps[i]["position"],
          team: maps[i]["team"],
          goodServes: maps[i]["goodServes"],
          badServes: maps[i]["badServes"],
          aces: maps[i]["aces"],
          assists: maps[i]["assists"],
          spikes: maps[i]["spikes"],
          tips: maps[i]["tips"]);
    });
  }

  Future<Player> getPlayer(String id) async {
    final db = await initialize();
    final List<Map<String, dynamic>> maps =
        await db.query('players', where: "id = ?", whereArgs: [id]);
    List playerList = List.generate(maps.length, (i) {
      return Player(
          id: maps[i]["id"],
          name: maps[i]["name"],
          number: maps[i]["number"],
          position: maps[i]["position"],
          team: maps[i]["team"],
          goodServes: maps[i]["goodServes"],
          badServes: maps[i]["badServes"],
          aces: maps[i]["aces"],
          assists: maps[i]["assists"],
          spikes: maps[i]["spikes"],
          tips: maps[i]["tips"]);
    });
    return playerList[0];
  }

  Future<List<GameStats>> getGameStats() async {
    final db = await initialize();
    final List<Map<String, dynamic>> maps = await db.query("gameStats");
    return List.generate(maps.length, (i) {
      return GameStats(
          gameID: maps[i]["gameID"],
          playerID: maps[i]["playerID"],
          name: maps[i]["name"],
          teamPoints: maps[i]["teamPoints"],
          oppPoints: maps[i]["oppPoints"],
          goodServes: maps[i]["goodServes"],
          badServes: maps[i]["badServes"],
          aces: maps[i]["aces"],
          assists: maps[i]["assists"],
          spikes: maps[i]["spikes"],
          tips: maps[i]["tips"],
          digs: maps[i]["digs"]);
    });
  }

  Future<List<Player>> getLineupPlayers(String lineupID) async {
    final db = await initialize();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM lineupEntries INNER JOIN players ON lineupEntries.playerID = players.id WHERE lineupEntries.lineupID = \"$lineupID\"");

    return List.generate(maps.length, (i) {
      return Player(
        id: maps[i]["id"],
        name: maps[i]["name"],
        number: maps[i]["number"],
        position: maps[i]["position"],
        team: maps[i]["team"],
        goodServes: maps[i]["goodServes"],
        badServes: maps[i]["badServes"],
        aces: maps[i]["aces"],
        assists: maps[i]["assists"],
        spikes: maps[i]["spikes"],
        tips: maps[i]["tips"],
        digs: maps[i]["digs"]
      );
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
    await db.delete('lineupEntries',
        where: '(lineupID = ? AND playerID = ?) ',
        whereArgs: [lineupID, playerID]);
  }

  Future<void> deleteGameStats(String id) async {
    final db = await initialize();
    await db.delete('gameStats', where: 'gameID = ?', whereArgs: [id]);
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
