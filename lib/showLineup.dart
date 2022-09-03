import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vbstat/dbHelper.dart';
import 'package:vbstat/players.dart';
import 'package:vbstat/lineups.dart';
import 'package:vbstat/showPlayer.dart';
import 'databaseClasses.dart';

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

class ShowLineupPage extends StatefulWidget {
  final Lineup lineup;
  const ShowLineupPage({Key? key, required this.lineup}) : super(key: key);

  @override
  ShowLineupState createState() => ShowLineupState();
}

class ShowLineupState extends State<ShowLineupPage> {
  void deleteDialog(BuildContext context, String lineupID, String playerID) {
    var alert = AlertDialog(
      title: const Text("Delete Player From Lineup?"),
      content: const Text(
          "If you select delete then you will remove this player from the lineup and any connected data! Do you want to continue?"),
      actions: [
        TextButton(
            onPressed: () {
              dbHelper().deleteLineupEntry(lineupID, playerID);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LineupPage()));
            },
            child: const Text("Delete"))
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void showLine() {
    List<Player> players = [];
    dbHelper().getLineupPlayers(widget.lineup.id).then((value) {
      List<Player> players = value;
    });
    // print(players);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lineup | " + widget.lineup.name),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LineupPage()));
              }),
        ),
        body: Center(
          child: Column(children: [
            const Text(
              "Players",
              style: TextStyle(fontSize: 36),
            ),
            const Divider(),
            FutureBuilder<List>(
                future: dbHelper().getLineupPlayers(widget.lineup.id),
                builder: (context, snapshot) {
                  // print(snapshot.data);
                  // print(widget.lineup);
                  if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: ((context, index) {
                          return Card(
                            // shadowColor: Colors.grey.shade300,
                            child: ListTile(
                                onLongPress: () => deleteDialog(
                                      context,
                                      widget.lineup.id,
                                      snapshot.data![index].id,
                                    ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShowPlayerPage(
                                              player: snapshot.data![index])));
                                },
                                title: Text(
                                  snapshot.data![index].name,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                subtitle: Text(snapshot.data![index].team,
                                    style: const TextStyle(fontSize: 20)),
                                leading: Text(
                                    snapshot.data![index].number.toString(),
                                    style: const TextStyle(fontSize: 18)),
                                trailing: Text(snapshot.data![index].position,
                                    style: const TextStyle(fontSize: 20))),
                          );
                        }));
                  } else {
                    return Center(
                      child: AlertDialog(
                        backgroundColor: const Color(0x997a7a7a),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        content: const Text(
                            "There are no lineups available, try adding a new one!"),
                      ),
                    );
                  }
                })
            // ListView.builder(
            //   itemCount: widget.roster,
            //   itemBuilder: (BuildContext context, int index) {
            //     return Card(
            //       child: ListTile(),
            //     );
            //   },
            // )
          ]),
        ));
  }
}
