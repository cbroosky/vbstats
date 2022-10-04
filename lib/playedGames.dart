import 'package:flutter/material.dart';
import 'package:vbstat/dbHelper.dart';
import 'package:vbstat/game.dart';
import 'package:vbstat/lineups.dart';
import 'package:vbstat/newGame.dart';

import 'main.dart';

class PlayedGamesPage extends StatefulWidget {
  const PlayedGamesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PlayedGamesState();
}

class PlayedGamesState extends State<PlayedGamesPage> {
  void deleteDialog(BuildContext context, String id) {
    var alert = AlertDialog(
      title: const Text("Delete Game?"),
      content: const Text("If you select delete then you will remove this game and its data! Do you want to continue?"),
      actions: [
        TextButton(
            onPressed: () {
              // print("Would have deleted game: $id");
              DBHelper().deleteGameStats(id);
              DBHelper().deleteGame(id);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PlayedGamesPage()));
            },
            child: const Text("Delete"))
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewGamePage()));
            },
            child: const Icon(Icons.add)),
        appBar: AppBar(
          title: const Text("Played Games"),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: "Home")));
              }),
        ),
        body: Center(
          child: ListView(children: [
            Column(
              children: [
                const Card(
                  elevation: 2,
                  child: ListTile(
                    tileColor: Color(0x99F44336),
                    title: Text("Name", style: TextStyle(fontSize: 28)),
                    leading: Text("#", style: TextStyle(fontSize: 28)),
                    trailing: Text("Position", style: TextStyle(fontSize: 18)),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(1)),
                FutureBuilder<List>(
                  future: DBHelper().getGames(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: ((context, index) {
                            return Card(
                                // shadowColor: Colors.grey.shade300,
                                child: ListTile(
                              onLongPress: () => deleteDialog(context, snapshot.data![index].id),
                              title: Text(
                                snapshot.data![index].name,
                                style: const TextStyle(fontSize: 24),
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const GamePage()));
                              },
                            ));
                          }));
                    } else {
                      return Center(
                        child: AlertDialog(
                          backgroundColor: const Color(0x997a7a7a),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          content: const Text("There are no games available, try adding a new one!"),
                        ),
                      );
                    }
                  },
                )
              ],
            )
          ]
              // )
              ),
        ));
  }
}
