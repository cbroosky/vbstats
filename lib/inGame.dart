import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vbstat/databaseClasses.dart';
import 'package:vbstat/dbHelper.dart';
import 'package:vbstat/playedGames.dart';
import 'package:vbstat/showPlayer.dart';

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
  List<Player> playersPlaying = [];
  List<Player> availableSubs = [];

  TextStyle general = const TextStyle(
    fontSize: 24,
  );
  TextStyle large = const TextStyle(
    fontSize: 42,
  );
  TextStyle buttonStyle = const TextStyle(
    fontSize: 24,
  );
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

  List<Row> playerDisplay() {
    List<Row> rows = [];
    DBHelper().getLineupPlayers(widget.game.id).then((value) {
      int index = 0;
      for (Player player in value) {
        if (index < 6) {
          playersPlaying.add(player);
        } else {
          availableSubs.add(player);
        }
        index += 1;
      }
    });
    for (int i = 0; i < 3; i++) {
      List<Flexible> rowItems = [];
      for (int j = 0; j < 2; j++) {
        rowItems.add(Flexible(
            fit: FlexFit.tight,
            child: DragTarget<StatAction>(onWillAccept: (data) {
              return true;
            }, onAccept: (data) {
              PlayerStat newAction = PlayerStat(playerID: playersPlaying[i + j].id, statAction: data);
              if (data.scoreAdjustment == 1) {
                teamPoints += 1;
              } else if (data.scoreAdjustment == -1) {
                oppPoints += 1;
              }
              actions.add(newAction);
              setState(() {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     duration: const Duration(milliseconds: 750),
                //     shape: const RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(10))),
                //     content: Text(snapshot.data![index].name + ": +1 " + data.name),
                //   ),
                // );
              });
            }, builder: (context, candidateData, rejectedData) {
              if ((i + j) < 6) {
                return SizedBox(
                  height: (MediaQuery.of(context).size.height - 70) / 3,
                  child: Card(
                    color: const Color(0x9900E5FF),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Center(
                            child: Text(
                          playersPlaying[i + j].name,
                          style: buttonStyle,
                        )),
                      )),
                );
              } else {
                return Container();
              }
            })));
      }
      rows.add(Row(
        children: rowItems,
      ));
    }
    return rows;
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
                      child: Padding(
                    padding: const EdgeInsets.all(15),
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

  void saveGame() {
    // DBHelper().alterGameTable();
    String gameID = DBHelper().generateID();
    DBHelper()
        .newGame(Game(id: gameID, name: widget.game.name, date: widget.game.date, teamPoints: teamPoints, oppPoints: oppPoints));
// TODO complete all actions and then save info
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
    if (MediaQuery.of(context).size.width < 1000) {
      general = const TextStyle(
        fontSize: 16,
      );
      large = const TextStyle(
        fontSize: 24,
      );
      buttonStyle = const TextStyle(
        fontSize: 14,
      );
    }

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
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
                        "Home Team |",
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
                          icon: Icon(
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
                        "| Away Team  ",
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
                            children: playerDisplay()
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
                  SliverAppBar(title: Text(widget.game.name), actions: [
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
