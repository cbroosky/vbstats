import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:vbstat/players.dart';
import 'package:vbstat/lineups.dart';
import 'databaseClasses.dart';
import 'dbHelper.dart';

var teamSelection = 0;
var positionSelection = 'Select Position';
var teamNames = ["Varsity", "Junior Varsity", "C Team"];

class NewPlayerPage extends StatefulWidget {
  const NewPlayerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NewPlayerPageState();
}

class NewPlayerPageState extends State<NewPlayerPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  // TextEditingController positionController = TextEditingController();

  void savePlayerInfo() {
    Player newPlayer = Player(
        id: dbHelper().generateID(),
        name: nameController.text,
        number: int.tryParse(numberController.text) ?? 999,
        position: positionSelection,
        team: teamNames[teamSelection]
        );
    // print("New Player: " + newPlayer.toString());
    dbHelper().newPlayer(newPlayer);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Player"),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              "Player Data",
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      "Name",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(left: 15, top: 25)),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                    width: 150,
                    height: 30,
                    child: TextField(
                      controller: nameController,
                      autofocus: true,
                      decoration:
                          const InputDecoration(hintText: "Player Name"),
                    ),
                  )
                ])
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        "Shirt Number",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                const Padding(padding: EdgeInsets.only(left: 15, top: 25)),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                    width: 150,
                    height: 30,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: numberController,
                      autofocus: true,
                      decoration:
                          const InputDecoration(hintText: "Player Number"),
                    ),
                  )
                ]),
                const Padding(padding: EdgeInsets.only(left: 15, top: 25)),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      "Position",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.only(left: 15, top: 25)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: positionSelection,
                      items: <String>[
                        'Select Position',
                        'Outside Hitter',
                        'Opposite',
                        'Setter',
                        'Middle Blocker',
                        'Libero',
                        'Defensive Specialist',
                        'Serving Specialist'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                      onChanged: (selection) => {
                        setState(
                            () => {positionSelection = selection ?? "Select"})
                      },
                    )
                  ],
                )

                // SizedBox(
                //   width: 150,
                //   height: 30,
                //   child: TextField(
                //     controller: positionController,
                //     autofocus: true,
                //     decoration:
                //         const InputDecoration(hintText: "Player Position"),
                //   ),
                // )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.only(top: 15)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      "Team",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(left: 15, top: 25)),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<int>(
                      value: teamSelection,
                      items: [
                        DropdownMenuItem(child: const Text("Varsity"), value: 0),
                        DropdownMenuItem(
                            child: const Text("Junior Varsity"), value: 1),
                        DropdownMenuItem(child: const Text("C Team"), value: 2),
                      ],
                      onChanged: (selection) => {
                        setState(() => {teamSelection = selection ?? 0})
                      },
                    )
                  ],
                ),

                const Padding(padding: EdgeInsets.only(left: 15)),

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
                onPressed: () {
                  savePlayerInfo();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PlayerPage()));
                },
                child: const Text("Save"))
          ]),
        )));
  }
}
