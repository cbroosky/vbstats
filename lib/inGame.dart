import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vbstat/databaseClasses.dart';
import 'package:vbstat/dbHelper.dart';
import 'playedGames.dart';
// import 'package:vbstat/playedGames.dart';

import 'actions.dart';

class InGamePage extends StatefulWidget {
  final Game game;
  const InGamePage({Key? key, required this.game}) : super(key: key);

  @override
  State<StatefulWidget> createState() => InGamePageState();
}

class InGamePageState extends State<InGamePage> {
  int teamPoints = 0;
  int oppPoints = 0;
  Set<Player> playersPlaying = {};
  Set<Player> availableSubs = {};

  TextStyle general = const TextStyle(
    fontSize: 24,
  );
  TextStyle large = const TextStyle(fontSize: 42, color: Colors.white);
  TextStyle buttonStyle = const TextStyle(fontSize: 36, color: Colors.white);
  // ButtonStyle pointStyle = ButtonStyle(
  //   textStyle: ,
  // );

  List<PlayerStat> actions = [];

  // void redoAction() {}

  String? undoAction() {
    if (actions.isNotEmpty) {
      PlayerStat removed = actions.removeLast();
      if (removed.statAction.scoreAdjustment == 1) {
        teamPoints -= 1;
      } else if (removed.statAction.scoreAdjustment == -1) {
        oppPoints -= 1;
      }
      setState(() {});
      return removed.statAction.name;
    } else {
      return null;
    }
  }

  Map<String, List<StatAction>> actionList = {
    "Serving": [
      StatAction(name: "Serve Attempt", column: "serveAtt", scoreAdjustment: 0),
      StatAction(name: "Ace", column: 'aces', scoreAdjustment: 1),
      StatAction(name: "Serve Error", column: "serveErr", scoreAdjustment: -1)
    ],
    "Passing": [
      StatAction(name: "Pass", column: "pass", scoreAdjustment: 0),
      StatAction(name: "Pass Error", column: "passErr", scoreAdjustment: -1)
    ],
    "Digging": [
      StatAction(name: "Dig", column: "dig", scoreAdjustment: 0),
      StatAction(name: "Dig Error", column: "digErr", scoreAdjustment: -1)
    ],
    "Kills": [
      StatAction(name: "Kill Attempt", column: "killAtt", scoreAdjustment: 0),
      StatAction(name: "Kill", column: "kill", scoreAdjustment: 1),
      StatAction(name: "Kill Error", column: "killErr", scoreAdjustment: -1)
    ],
    "Assisting": [
      StatAction(name: "Assist", column: "assists", scoreAdjustment: 0),
      StatAction(name: "Assist Error", column: "assistsErr", scoreAdjustment: -1)
    ],
    "Blocking": [
      StatAction(name: "Block Attempt", column: "blockAtt", scoreAdjustment: 0),
      StatAction(name: "Block", column: "block", scoreAdjustment: 1),
      StatAction(name: "Block Error", column: "blockErr", scoreAdjustment: -1)
    ]
  };

  List<Widget> playerDisplay() {
    List<Widget> playerRows = [];

    DBHelper().getLineupPlayers(widget.game.lineupId).then((List<Player> value) {
      print('running get lineup.then');
      int index = 0;
      for (Player player in value) {
        if (index < 6) {
          playersPlaying.add(player);
        } else {
          availableSubs.add(player);
        }
        index += 1;
      }
      for (int i = 0; i < 3; i++) {
        List<Flexible> rowItems = [];
        rowItems.add(Flexible(
            fit: FlexFit.tight,
            child: DragTarget<StatAction>(onWillAccept: (data) {
              return true;
            }, onAccept: (data) {
              PlayerStat newAction = PlayerStat(playerID: playersPlaying.elementAt(i).id, statAction: data);
              if (data.scoreAdjustment == 1) {
                teamPoints += 1;
              } else if (data.scoreAdjustment == -1) {
                oppPoints += 1;
              }
              actions.add(newAction);
              setState(() {});
              // setState(() {
              //    ScaffoldMessenger.of(context).showSnackBar(
              //      SnackBar(
              //        duration: const Duration(milliseconds: 750),
              //        shape: const RoundedRectangleBorder(
              //            borderRadius: BorderRadius.all(Radius.circular(10))),
              //        content: Text(snapshot.data![index].name + ": +1 " + data.name),
              //      ),
              //    );
              // });
            }, builder: (context, candidateData, rejectedData) {
              return GestureDetector(
                  onTap: () {
                    print(playersPlaying.elementAt(i + 3).id);
                    print("Hello World");
                  },
                  onDoubleTap: () {
                    print("TEst");
                  },
                  child: SizedBox(
                    height: (MediaQuery.of(context).size.height - 70) / 3,
                    child: Container(
                        decoration: BoxDecoration(color: const Color(0x9900E5FF), borderRadius: BorderRadius.circular(5)),
                        margin: const EdgeInsets.all(2),
                        child: Padding(
                          padding: const EdgeInsets.all(1),
                          child: Center(
                              child: Text(
                            playersPlaying.elementAt(i).name,
                            style: const TextStyle(fontSize: 28, color: Colors.white),
                          )),
                        )),
                  ));
            })));
        rowItems.add(Flexible(
            fit: FlexFit.tight,
            child: DragTarget<StatAction>(onWillAccept: (data) {
              return true;
            }, onAccept: (data) {
              PlayerStat newAction = PlayerStat(playerID: playersPlaying.elementAt(i + 3).id, statAction: data);
              if (data.scoreAdjustment == 1) {
                teamPoints += 1;
              } else if (data.scoreAdjustment == -1) {
                oppPoints += 1;
              }
              actions.add(newAction);
              setState(() {});
              // setState(() {
              //    ScaffoldMessenger.of(context).showSnackBar(
              //      SnackBar(
              //        duration: const Duration(milliseconds: 750),
              //        shape: const RoundedRectangleBorder(
              //            borderRadius: BorderRadius.all(Radius.circular(10))),
              //        content: Text(snapshot.data![index].name + ": +1 " + data.name),
              //      ),
              //    );
              // });
            }, builder: (context, candidateData, rejectedData) {
              return InkWell(
                  onTap: () {
                    print(playersPlaying.elementAt(i + 3).id);
                    print("Hello World");
                  },
                  
                  child: SizedBox(
                      height: (MediaQuery.of(context).size.height - 70) / 3,
                      child: Container(
                        decoration: BoxDecoration(color: const Color(0x9900E5FF), borderRadius: BorderRadius.circular(5)),
                        margin: const EdgeInsets.all(2),
                        child: Padding(
                          padding: const EdgeInsets.all(1),
                          child: Center(
                              child: Text(
                            playersPlaying.elementAt(i + 3).name,
                            style: const TextStyle(fontSize: 28, color: Colors.white),
                          )),
                        ),
                      )));
            })));
        playerRows.add(Row(
          children: rowItems,
        ));
      }
      setState(() {});
    });

    return playerRows;
  }

  List<Widget> buttonDisplay() {
    List<Row> rows = [];
    // List<Expanded> rows = [];
    actionList.forEach((key, value) {
      List<Widget> buttons = [];

      for (StatAction action in value) {
        buttons.add(Flexible(
          fit: FlexFit.tight,
          child: Draggable(
              data: action,
              feedback: SizedBox(
                  height: (MediaQuery.of(context).size.height - 70) / actionList.length,
                  child: Card(
                      color: const Color(0xFFFF6D00),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Center(
                            child: Text(
                          action.name,
                          style: buttonStyle,
                        )),
                      ))),
              child: SizedBox(
                  height: (MediaQuery.of(context).size.height - 70) / actionList.length,
                  child: Card(
                      color: const Color(0xFFFF6D00),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Center(
                            child: Text(
                          action.name,
                          style: buttonStyle,
                        )),
                      )))),
        ));
      }
      Row newRow = Row(mainAxisSize: MainAxisSize.min, children: buttons);
      // Expanded newRow = Expanded(child:Row(children: buttons));
      rows.add(newRow);
    });
    return rows;
  }

  List<Widget> players = [];

  @override
  void initState() {
    players = playerDisplay();

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

// Step 3
  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  void saveGame() {
    // DBHelper().alterGameTable();
    String gameID = DBHelper().generateID();
    DBHelper().newGame(Game(
        id: gameID,
        lineupId: widget.game.lineupId,
        teamName: widget.game.teamName,
        oppName: widget.game.oppName,
        date: widget.game.date,
        teamPoints: teamPoints,
        oppPoints: oppPoints));
    Set<String> playerIDs = {};
    if (actions.isNotEmpty) {
      for (PlayerStat pStat in actions) {
        if (pStat.playerID != "") {
          GameStats newStat = GameStats(gameID: gameID, playerID: pStat.playerID);
          if (playerIDs.contains(pStat.playerID)) {
            DBHelper().updateGameStats(newStat, pStat.statAction.column);
          } else {
            DBHelper().newGameStats(newStat);

            playerIDs.add(pStat.playerID);
          }
        }
      }
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PlayedGamesPage()));
  }

  // final actionList = {
  //   "Serving": ["Serve Attempt", "Ace", "Serve Error"],
  //   "Passing": ["Pass", "Pass Error"],
  //   "Digging": ["Dig", "Dig Error"],
  //   "Kills": ["Kill Attempt", "Kill", "Kill Error"],
  //   "Assisting": ["Assist", "Assist Error"],
  //   "Blocking": ["Block Attempt", "Block", "Block Error"]
  // };
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    var screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 1000) {
      general = const TextStyle(
        fontSize: 16,
      );
      large = const TextStyle(
        fontSize: 24,
      );
      buttonStyle = const TextStyle(
        fontSize: 14,
      );
    } else if (screenWidth > 1200) {
      general = const TextStyle(
        fontSize: 36,
      );
      large = const TextStyle(
        fontSize: 42,
      );
      buttonStyle = const TextStyle(
        fontSize: 26,
      );
    }

    return Scaffold(
        // list of images for scrolling
        // body: SingleChildScrollView(
        //         child:
        body: NestedScrollView(
            body: ListView(
              // mainAxisSize: MainAxisSize.max,
              children: [
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${widget.game.teamName} |",
                        style: general,
                      ),
                      TextButton(
                        onPressed: () {
                          teamPoints += 1;
                          actions.add(PlayerStat(
                              playerID: "", statAction: StatAction(name: "Add Point", column: "n/a", scoreAdjustment: 1)));
                          setState(() {});
                        },
                        style: TextButton.styleFrom(foregroundColor: Colors.white, textStyle: large),

                        // style: large,
                        child: Text(teamPoints.toString()),
                      ),
                      // Text(
                      //   "|",
                      //   style: general,
                      // ),
                      IconButton(
                          alignment: Alignment.center,
                          onPressed: () {
                            String? action = undoAction();
                            // ignore: unnecessary_null_comparison
                            if (action != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(milliseconds: 750),
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                  content: Text("Removed: $action"),
                                ),
                              );
                            } else {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     duration: Duration(milliseconds: 750),
                              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              //     content: Text("No actions have been taken!"),
                              //   ),
                              // );
                            }
                          },
                          icon: const Icon(
                            Icons.undo_rounded,
                            // size: large.fontSize
                          )),
                      TextButton(
                        onPressed: () {
                          oppPoints += 1;
                          actions.add(PlayerStat(
                              playerID: "", statAction: StatAction(name: "Add Point", column: "n/a", scoreAdjustment: -1)));
                          setState(() {});
                        },
                        // style: large,
                        style: TextButton.styleFrom(foregroundColor: Colors.white, textStyle: large),
                        child: Text(oppPoints.toString()),
                      ),
                      Text(
                        "| ${widget.game.oppName}",
                        style: general,
                      ),
                    ],
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: players
                            // FutureBuilder<List>(
                            //   future: DBHelper().getLineupPlayers(widget.game.id),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                            //       return ListView.builder(
                            //           physics: const ClampingScrollPhysics(),
                            //           shrinkWrap: true,
                            //           itemCount: snapshot.data!.length,
                            //           itemBuilder: ((context, index) {
                            //             // TODO add action on drop
                            //             return DragTarget<StatAction>(onWillAccept: (data) {
                            //               return true;
                            //             }, onAccept: (data) {
                            //               PlayerStat newAction = PlayerStat(playerID: snapshot.data![index].id, statAction: data);
                            //               if (data.scoreAdjustment == 1) {
                            //                 teamPoints += 1;
                            //               } else if (data.scoreAdjustment == -1) {
                            //                 oppPoints += 1;
                            //               }
                            //               actions.add(newAction);
                            //               setState(() {
                            //                 // ScaffoldMessenger.of(context).showSnackBar(
                            //                 //   SnackBar(
                            //                 //     duration: const Duration(milliseconds: 750),
                            //                 //     shape: const RoundedRectangleBorder(
                            //                 //         borderRadius: BorderRadius.all(Radius.circular(10))),
                            //                 //     content: Text(snapshot.data![index].name + ": +1 " + data.name),
                            //                 //   ),
                            //                 // );
                            //               });
                            //             }, builder: (context, candidateData, rejectedData) {
                            //               if (index < 6) {
                            //                 playersPlaying.add(snapshot.data![index]);
                            //                 return SizedBox(
                            //                     height: (MediaQuery.of(context).size.height - 70) / 3,
                            //                     child: Card(
                            //                       shadowColor: Colors.grey.shade300,
                            //                       child: Center(child: Text(snapshot.data![index].name, style: large)),
                            //                       // child: ListTile(
                            //                       //   leading: Text((index + 1).toString(), style: general),
                            //                       //   title: Text(snapshot.data![index].name, style: general),
                            //                       //   trailing: Text(snapshot.data![index].position),
                            //                       //   onTap: () {},
                            //                     ));
                            //               } else {
                            //                 availableSubs.add(snapshot.data![index]);
                            //                 return Container();
                            //               }
                            //             });
                            //           }));
                            //     } else {
                            //       return Center(
                            //         child: AlertDialog(
                            //           backgroundColor: const Color(0x997a7a7a),
                            //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            //           content: const Text("There are no players available, try making a new one!"),
                            //         ),
                            //       );
                            //     }
                            //   },
                            // ),
                            // ],
                            ),
                      ),
                      Expanded(
                        flex: 1,
                        child:
                            // SingleChildScrollView(
                            //   // physics: const ClampingScrollPhysics(),
                            //   child:
                            Column(
                                mainAxisSize: MainAxisSize.min,
                                // children: [
                                // ListView(
                                //   shrinkWrap: true,

                                children: buttonDisplay()),
                        // children: [
                        //   ListView.builder(
                        //       shrinkWrap: true,
                        //       itemCount: actionList.length,
                        //       itemBuilder: (BuildContext context, int keyIndex) {
                        //         String key = actionList.keys.elementAt(keyIndex);
                        //         return rowMaker(key);
                        //         // )
                        //         // Expanded(child: Row(children: [
                        //         // ]),)
                        //         // ]);
                        //       })
                        // ],
                        // ),
                      )

                      // )
                    ]),
              ],
            ),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(title: Text(widget.game.teamName), actions: [
                    // IconButton(
                    //     onPressed: () {
                    //       String action = undoAction();
                    //       // ignore: unnecessary_null_comparison
                    //       if (action != null) {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           SnackBar(
                    //             duration: const Duration(milliseconds: 750),
                    //             shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    //             content: Text("Removed: $action"),
                    //           ),
                    //         );
                    //       } else {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(
                    //             duration: Duration(milliseconds: 750),
                    //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    //             content: Text("No actions have been taken!"),
                    //           ),
                    //         );
                    //       }
                    //     },
                    //     icon: const Icon(Icons.repeat)),
                    // IconButton(
                    //     onPressed: () {
                    //       redoAction();
                    //     },
                    //     icon: const Icon(Icons.redo)),
                    IconButton(
                        onPressed: () {
                          saveGame();
                        },
                        icon: const Icon(Icons.save)),
                  ]),
                ]));
  }
}
