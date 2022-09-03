import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vbstat/dbHelper.dart';
import 'package:vbstat/players.dart';
import 'databaseClasses.dart';

var player;
// String playerName = '';
// int playerNumber = 0;
// String playerPosition = '';
// String playerTeam = '';
// int playerGoodServes = 0;
// int playerBadServes = 0;
// int playerAces = 0;
// int playerAssists = 0;
// int playerSpikes = 0;
// int playerTips = 0;

class ShowPlayerPage extends StatefulWidget {
  final Player player;
  const ShowPlayerPage({Key? key, required this.player}) : super(key: key);

  @override
  ShowPlayerState createState() => ShowPlayerState();
}

class ShowPlayerState extends State<ShowPlayerPage> {
  @override
  Widget build(BuildContext context) {
    //

    return Scaffold(
        appBar: AppBar(
          title: Text("Player " + widget.player.name),
          // leading: IconButton(
          //     icon: const Icon(Icons.arrow_back),
          //     onPressed: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const PlayerPage()));
          //     }),
        ),
        body: Center(
          child: Column(children: [
            const Text("Player Stats", style: TextStyle(fontSize: 36),),
            const Divider(),
            Card(
                child: ListTile(
              title: const Text("Good Serves"),
              trailing: Text(widget.player.goodServes.toString()),
            )),
            Card(
                child: ListTile(
              title: const Text("Bad Serves"),
              trailing: Text(widget.player.badServes.toString()),
            )),
            Card(
                child: ListTile(
              title: const Text("Aces"),
              trailing: Text(widget.player.aces.toString()),
            )),
            Card(
                child: ListTile(
              title: const Text("Assists"),
              trailing: Text(widget.player.assists.toString()),
            )),
            Card(
                child: ListTile(
              title: const Text("Spikes"),
              trailing: Text(widget.player.spikes.toString()),
            )),
            Card(
                child: ListTile(
              title: const Text("tips"),
              trailing: Text(widget.player.tips.toString()),
            )),
            Card(
                child: ListTile(
              title: const Text("Digs"),
              trailing: Text(widget.player.digs.toString()),
            )),
          ]),
        ));
  }
}
