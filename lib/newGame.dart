import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("New Game")),
        body: Center(
            child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              "Game Info",
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
            const Padding(padding: EdgeInsets.only(top: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Name",
                  style: TextStyle(fontSize: 20),
                ),
                const Padding(padding: EdgeInsets.only(left: 15, top: 25)),
                SizedBox(
                  width: 150,
                  height: 30,
                  child: TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: const InputDecoration(hintText: "Game Name"),
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
                    future: dbHelper().getLineups(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.hasData) {
                        return DropdownButton<String>(
                            value: lineupSelection,
                            items: [
                                  const DropdownMenuItem<String>(
                                      value: "Select Lineup",
                                      child: Text("Select Lineup"))
                                ] +
                                snapshot.data!
                                    .map((lineup) => DropdownMenuItem<String>(
                                        value: lineup.id,
                                        child: Text(lineup.name)))
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            content: const Text(
                                "There are no lineups available, try adding a new one!"),
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
                  DateTime now = DateTime.now();
                  DateTime date = DateTime(now.year, now.month, now.day);
                  Game newGame = Game(
                      id: lineupSelection,
                      name: nameController.text,
                      date: date);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InGamePage(game: newGame,)));
                },
                child: const Text("Save"))
          ]),
        )));
  }
}
