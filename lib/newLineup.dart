import 'package:flutter/material.dart';
import 'package:vbstat/newPlayer.dart';
import 'selectPlayers.dart';

class NewLineupPage extends StatefulWidget {
  const NewLineupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NewLineupPageState();
}

class NewLineupPageState extends State<NewLineupPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Roster"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(fontSize: 20),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 15, bottom: 50)),
                  SizedBox(
                    width: 250,
                    height: 30,
                    child: TextField(
                      controller: nameController,
                      autofocus: true,
                      decoration:
                          const InputDecoration(hintText: "Roster Name"),
                    ),
                  )
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectPlayersPage(
                                  name: nameController.text,
                                )));
                  },
                  child: Text("Next"))
            ],
          ),
        ),
      ),
    );
    // TODO: implement build
  }
}
