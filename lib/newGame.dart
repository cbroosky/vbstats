import 'package:flutter/material.dart';
import 'package:vbstat/dbHelper.dart';

import 'databaseClasses.dart';
import 'inGame.dart';

String lineupSelection = "Select Lineup";

class NewGamePage extends StatefulWidget {
  const NewGamePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NewGameState();
}

class NewGameState extends State<NewGamePage> {
  TextEditingController teamController = TextEditingController();
  TextEditingController oppController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // DBHelper().alterGameTable();
    return Scaffold(
        appBar: AppBar(title: const Text("New Game")),
        body: Center(
            child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              "Game Info",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
            ),
            const Padding(padding: EdgeInsets.only(top: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Team Name",
                  style: TextStyle(fontSize: 20),
                ),
                const Padding(padding: EdgeInsets.only(left: 15, top: 25)),
                SizedBox(
                  width: 150,
                  height: 30,
                  child: TextField(
                    controller: teamController,
                    autofocus: true,
                    decoration: const InputDecoration(hintText: "Team Name"),
                  ),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Opponent Name",
                  style: TextStyle(fontSize: 20),
                ),
                const Padding(padding: EdgeInsets.only(left: 15, top: 25)),
                SizedBox(
                  width: 150,
                  height: 30,
                  child: TextField(
                    controller: oppController,
                    autofocus: true,
                    decoration: const InputDecoration(hintText: "Opponent Name"),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.only(top: 15)),
                const Text(
                  "Lineup Set 1",
                  style: TextStyle(fontSize: 20),
                ),
                const Padding(padding: EdgeInsets.only(left: 15)),
                FutureBuilder<List<Lineup>>(
                    future: DBHelper().getLineups(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.hasData) {
                        return DropdownButton<String>(
                            value: lineupSelection,
                            items: [const DropdownMenuItem<String>(value: "Select Lineup", child: Text("Select Lineup"))] +
                                snapshot.data!
                                    .map((lineup) => DropdownMenuItem<String>(value: lineup.id, child: Text(lineup.name)))
                                    .toList(),
                            onChanged: (value) {
                              setState(() {
                                lineupSelection = value!;
                              });
                            });
                      } else {
                        return Center(
                          child: AlertDialog(
                            backgroundColor: const Color(0x997a7a7a),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            content: const Text("There are no games available, try adding a new one!"),
                          ),
                        );
                      }
                    })
                // SizedBox(
                //   width: 150,
                //   height: 30,
                //   child: TextField(
                //     controller: teamController,
                //     autofocus: true,
                //     decoration: const InputDecoration(hintText: "Player Team"),
                //   ),
                // )
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  // DateTime now = DateTime.now();
                  // DateTime date = DateTime(now.year, now.month, now.day);
                  int millisSinceEpoch = DateTime.now().millisecondsSinceEpoch;
                  Game newGame = Game(id: "", lineupId: lineupSelection, teamName: teamController.text, oppName: oppController.text, date: millisSinceEpoch);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InGamePage(
                                game: newGame,
                              )));
                },
                child: const Text("Save"))
          ]),
        )));
  }
}
