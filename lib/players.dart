import 'package:flutter/material.dart';
import 'package:vbstat/main.dart';
import 'package:vbstat/newPlayer.dart';
import 'package:vbstat/showPlayer.dart';
import 'dbHelper.dart';
import 'databaseClasses.dart';
import 'newLineup.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PlayerPageState();
}

class PlayerPageState extends State {
  void deleteDialog(BuildContext context, String id) {
    var alert = AlertDialog(
      title: const Text("Delete Player?"),
      content: const Text(
          "If you select delete then you will remove this player and their data! Do you want to continue?"),
      actions: [
        TextButton(
            onPressed: () {
              dbHelper().deletePlayer(id);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PlayerPage()));
            },
            child: const Text("Delete"))
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewPlayerPage()));
            }),
        appBar: AppBar(
          title: const Text("Players"),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage(title: "Home")));
              }),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Card(
              elevation: 2,
              child: ListTile(
                tileColor: Color(0x99F44336),
                title: Text("Name", style: TextStyle(fontSize: 28)),
                subtitle: Text(
                  "Team",
                  style: TextStyle(fontSize: 18),
                ),
                leading: Text("#", style: TextStyle(fontSize: 28)),
                trailing: Text("Position", style: TextStyle(fontSize: 18)),
              ),
            ),
            const Padding(padding: EdgeInsets.all(1)),
            FutureBuilder<List>(
              future: dbHelper().getPlayers(),
              builder: (context, snapshot) {
                if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: ((context, index) {
                        return Card(
                          child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowPlayerPage(
                                            player: snapshot.data![index])));
                              },
                              onLongPress: () => deleteDialog(
                                  context, snapshot.data![index].id),
                              title: Text(
                                snapshot.data![index].name,
                                style: const TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(snapshot.data![index].team,
                                  style: const TextStyle(fontSize: 20)),
                              leading: Text(
                                  snapshot.data![index].number.toString(),
                                  style: const TextStyle(fontSize: 18)),
                              trailing: Text(snapshot.data![index].position,
                                  style: const TextStyle(fontSize: 20))),
                        );
                      }));
                } else {
                  return Center(
                    child: AlertDialog(
                      backgroundColor: const Color(0x997a7a7a),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      content: const Text(
                          "There are no players available, try adding a new one!"),
                    ),
                  );
                }
              },
            )
          ],
        )
            // )
            ));
  }
}
