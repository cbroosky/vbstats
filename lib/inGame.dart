import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vbstat/databaseClasses.dart';
import 'package:vbstat/dbHelper.dart';

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

  // void redoAction() {}

  StatAction? undoAction() {
    return StatAction(name: "place holder", affectsScore: false, column: "none");
  }

  Map<String, List<List<String>>> actionList = {
    "Serving": [
      ["Serve Attempt", "serveAtt"],
      ["Ace", 'aces'],
      ["Serve Error", "serveErr"]
    ],
    "Passing": [
      ["Pass", "pass"],
      ["Pass Error", "passErr"]
    ],
    "Digging": [
      ["Dig", "dig"],
      ["Dig Error", "digErr"]
    ],
    "Kills": [
      ["Kill Attempt", "killAtt"],
      ["Kill", "kill"],
      ["Kill Error", "killErr"]
    ],
    "Assisting": [
      ["Assist", "assists"],
      ["Assist Error", "assistsErr"]
    ],
    "Blocking": [
      ["Block Attempt", "blockAtt"],
      ["Block", "block"],
      ["Block Error", "blockErr"]
    ]
  };

  List<Widget> buttonDisplay() {
    List<Row> rows = [];
    // List<Expanded> rows = [];
    actionList.forEach((key, value) {
      List<Widget> buttons = [];

      for (List<String> element in value) {
        buttons.add(Flexible(
          fit: FlexFit.tight,
          child: Draggable(
              data: element[1],
              feedback: Card(
                  child: Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                    child: Text(
                  element[0],
                  style: buttonStyle,
                )),
              )),
              child: SizedBox(
                  height: (MediaQuery.of(context).size.height - 150) / actionList.length,
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Center(
                        child: Text(
                      element[0],
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



  void saveGame() {}

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
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return Scaffold(
        appBar: AppBar(title: Text(widget.game.name),
            // leading: IconButton(
            //     icon: const Icon(Icons.arrow_back),
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const GamePage()));
            //     }),
            actions: [
              IconButton(
                  onPressed: () {
                    StatAction? action = undoAction();
                    if (action != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(milliseconds: 750),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          content: Text("Removed: ${action.name}"),
                        ),
                      );
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(milliseconds: 750),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          content: Text("No actions have been taken!"),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.repeat)),
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
        body: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Home Team |  ",
                    style: general,
                  ),
                  Text(
                    teamPoints.toString(),
                    style: large,
                  ),
                  Text(
                    "   |   ",
                    style: general,
                  ),
                  Text(
                    oppPoints.toString(),
                    style: large,
                  ),
                  Text(
                    "  | Away Team  ",
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
                      children: [
                        FutureBuilder<List>(
                          future: dbHelper().getLineupPlayers(widget.game.id),
                          builder: (context, snapshot) {
                            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: ((context, index) {
                                    return DragTarget<String>(onWillAccept: (data) {
                                      return true;
                                    }, onAccept: (data) {
                                      setState(() {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            duration: const Duration(milliseconds: 750),
                                            shape:
                                                const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                            content: Text(snapshot.data![index].name + ": +1 " + data),
                                          ),
                                        );
                                      });
                                    }, builder: (context, candidateData, rejectedData) {
                                      if (index < 6) {
                                        playersPlaying.add(snapshot.data![index]);
                                        return SizedBox(
                                            height: (MediaQuery.of(context).size.height - 150) / 6,
                                            child: Card(
                                              shadowColor: Colors.grey.shade300,
                                              child: ListTile(
                                                leading: Text((index + 1).toString(), style: const TextStyle(fontSize: 18)),
                                                title: Text(snapshot.data![index].name, style: general),
                                                trailing: Text(snapshot.data![index].position),
                                                onTap: () {},
                                              ),
                                            ));
                                      } else {
                                        availableSubs.add(snapshot.data![index]);
                                        return Container();
                                      }
                                    });
                                    
                                  }));
                            } else {
                              return Center(
                                child: AlertDialog(
                                  backgroundColor: const Color(0x997a7a7a),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  content: const Text("There are no players available, try making a new one!"),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child:
                        // SingleChildScrollView(child:
                        Column(
                      mainAxisSize: MainAxisSize.max,
                      children: buttonDisplay(),
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
                    ),
                  )

                  // )
                ]),
          ],
        )));
  }
}
