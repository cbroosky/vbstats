import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

int teamSelection = 0;

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
              "Player Data",
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
            const Padding(padding: EdgeInsets.only(top: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    decoration: const InputDecoration(hintText: "Player Name"),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.only(top: 15)),
                const Text(
                  "Team",
                  style: TextStyle(fontSize: 20),
                ),
                const Padding(padding: EdgeInsets.only(left: 15)),
                DropdownButton<int>(
                  value: teamSelection,
                  items: const [
                    DropdownMenuItem(child: Text("Varsity"), value: 0),
                    DropdownMenuItem(child: Text("Junior Varsity"), value: 1),
                    DropdownMenuItem(child: Text("C Team"), value: 2),
                  ],
                  onChanged: (selection) => {
                    setState(() => {teamSelection = selection ?? 0})
                  },
                )
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
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const InGamePage()));
                },
                child: Text("Save"))
          ]),
        )));
  }
}
