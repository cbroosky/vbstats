import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vbstat/dbHelper.dart';

import 'databaseClasses.dart';

class GamePage extends StatefulWidget {
  final Game game;
  const GamePage({Key? key, required this.game}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  var orderValue = "serveAtt";

  TextStyle pointStyle = const TextStyle(
    fontSize: 24,
  );
  TextStyle nameStyle = const TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
  );

  List<Widget> getgameStats() {
    List<Widget> playerInfo = [];
    print(widget.game.id);
    DBHelper().getGameStats(widget.game.id, orderValue).then((value) {
      // pr/nt(value);
      for (GameStats stats in value) {
        String playerName = '';
        DBHelper().getPlayer(stats.playerID).then((player) {
          print(player.name);
          playerInfo.add(Card(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        player.name,
                        style: nameStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            // flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Aces:", style: pointStyle),
                                Text("Serve Attempts:", style: pointStyle),
                                Text("Serve Errors:", style: pointStyle),
                                Text("Digs:", style: pointStyle),
                                Text("Dig Errors:", style: pointStyle),
                                Text("Passes:", style: pointStyle),
                                Text("Pass Errors:", style: pointStyle),
                                Text("Kills:", style: pointStyle),
                                Text("Kill Attempts:", style: pointStyle),
                                Text("Kill Errors:", style: pointStyle),
                                Text("Assists:", style: pointStyle),
                                Text("Assist Errors:", style: pointStyle),
                                Text("Blocks:", style: pointStyle),
                                Text("Block Attempts:", style: pointStyle),
                                Text("Block Errors:", style: pointStyle),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(5)),
                          Flexible(
                            // flex: 1,
                            fit: FlexFit.loose,

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${stats.aces}", style: pointStyle),
                                Text("${stats.serveAtt}", style: pointStyle),
                                Text("${stats.serveErr}", style: pointStyle),
                                Text("${stats.dig}", style: pointStyle),
                                Text("${stats.digErr}", style: pointStyle),
                                Text("${stats.pass}", style: pointStyle),
                                Text("${stats.passErr}", style: pointStyle),
                                Text("${stats.kill}", style: pointStyle),
                                Text("${stats.killAtt}", style: pointStyle),
                                Text("${stats.killErr}", style: pointStyle),
                                Text("${stats.assists}", style: pointStyle),
                                Text("${stats.assistErr}", style: pointStyle),
                                Text("${stats.block}", style: pointStyle),
                                Text("${stats.blockAtt}", style: pointStyle),
                                Text("${stats.blockErr}", style: pointStyle),
                              ],
                            ),
                          )
                        ],
                      )
                    ])),
          ));
          setState(() {});
        });
      }
    });

    return playerInfo;
  }

  List<Widget> stats = [];
  @override
  void initState() {
    stats = getgameStats();
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

// Step 3
  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List<Widget> infoCards = getLineupStats();
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: Text(widget.game.teamName),
                ),
              ],
          body: SingleChildScrollView(
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Column(
                        children: [
                          Text(widget.game.teamName, style: pointStyle),
                          Text(
                            widget.game.teamPoints.toString(),
                            style: pointStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // const Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0)),
                  Expanded(
                    child: Card(
                      child: Column(
                        children: [
                          Text(widget.game.oppName, style: pointStyle),
                          Text(
                            widget.game.oppPoints.toString(),
                            style: pointStyle,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Order by:",
                    style: pointStyle,
                  ),
                  const Padding(padding: EdgeInsets.all(10),),
                  DropdownButton(
                    value: orderValue,
                    items: const [
                      DropdownMenuItem<String>(value: "aces", child: Text("Aces")),
                      DropdownMenuItem<String>(value: "serveAtt", child: Text("Serve Attempts")),
                      DropdownMenuItem<String>(value: "serveErr", child: Text("Serve Errors")),
                      DropdownMenuItem<String>(value: "digs", child: Text("Digs")),
                      DropdownMenuItem<String>(value: "digErr", child: Text("Dig Errors")),
                      DropdownMenuItem<String>(value: "pass", child: Text("Pass")),
                      DropdownMenuItem<String>(value: "passErr", child: Text("Pass Errors")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        orderValue = value!;
                        stats = getgameStats();
                      });
                    },
                  )
                ],
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: stats.length,
                  itemBuilder: ((context, index) {
                    // Card newCard;
                    // DBHelper().getPlayer(infoCards[index].playerID).then((value) {
                    //     newCard = Card(
                    //     child: Column(children: [
                    //       Text(
                    //         value.name,
                    //         style: pointStyle,
                    //       )
                    //     ]),
                    //   );
                    //   return newCard;
                    // });
                    // return const Text("no content");
                    return stats[index];
                  })),
            ]),
          )),
    );
  }
}
