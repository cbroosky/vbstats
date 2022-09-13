import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vbstat/databaseClasses.dart';
import 'package:vbstat/dbHelper.dart';
import 'package:vbstat/lineups.dart';

class SelectPlayersPage extends StatefulWidget {
  final String name;
  const SelectPlayersPage({Key? key, required this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SelectPlayersState();
}

class SelectPlayersState extends State<SelectPlayersPage> {
  Set selected = {};
  String lineupID = dbHelper().generateID();
  void saveRoster() {
    for (String id in selected) {
      LineupEntry newLineupEntry = LineupEntry(
          lineupID: lineupID, playerID: id, rotation: Random().nextInt(9));
      dbHelper().newLineupEntry(newLineupEntry);
    }
    Lineup newLineup = Lineup(id: lineupID, name: widget.name);
    dbHelper().newLineup(newLineup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.check),
            onPressed: () {
              saveRoster();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LineupPage()));
            }),
        appBar: AppBar(title: const Text("Select Players")),
        body:
        
            // Row(
            //   children: [
            Column(
          children: [
            Expanded(
              flex: 1,
              child: FutureBuilder<List>(
              future: dbHelper().getPlayers(),
              builder: (context, snapshot) {
                if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: ((context, index) {
                        return Card(
                          shadowColor: Colors.grey.shade300,
                          child: ListTile(
                              tileColor:
                                  selected.contains(snapshot.data![index].id)
                                      ? const Color(0x9900E5FF)
                                      : const Color.fromARGB(150, 173, 32, 32),
                              onTap: () {
                                if (selected
                                    .contains(snapshot.data![index].id)) {
                                  selected.remove(snapshot.data![index].id);
                                } else {
                                  selected.add(snapshot.data![index].id);
                                }

                                setState(() {
                                });
                              },
                              leading: selected
                                    .contains(snapshot.data![index].id) ? selected.toList().indexOf(snapshot.data![index].id) < 6 ? Text((selected.toList().indexOf(snapshot.data![index].id)+1).toString()): const Text("Sub"): const Text(""),
                              title: Text(snapshot.data![index].name,
                                  style: const TextStyle(fontSize: 24)),
                              trailing: Text(snapshot.data![index].position)),
                        );
                      }));
                } else {
                  return Center(
                    child: AlertDialog(
                      backgroundColor: const Color(0x997a7a7a),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      content: const Text(
                          "There are no players available, try making a new one!"),
                    ),
                  );
                }
              },
            ),)
            
          ],
          //   )
          // ],
        ));
  }
}
