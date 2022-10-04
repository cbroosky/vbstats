import 'package:flutter/material.dart';
import 'package:vbstat/main.dart';
import 'package:vbstat/showLineup.dart';
import 'dbHelper.dart';
import 'newLineup.dart';

bool editing = false;

class LineupPage extends StatefulWidget {
  const LineupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LineupState();
}

class LineupState extends State {
  // buildRosterList() async {
  //   List<Player> rosters = await dbHelper().getRosters();
  //   ListView newList = ListView.builder(
  //       itemCount: rosters.length,
  //       itemBuilder: ((context, index) {
  //         print(rosters[index].name);
  //         return Card(
  //           shadowColor: Colors.grey.shade300,
  //           child: ListTile(
  //               leading: Text(rosters[index].name),
  //               trailing: Text(rosters[index].id.toString())),
  //         );
  //       }));
  //   return newList;
  // }
  void deleteDialog(BuildContext context, String id) {
    var alert = AlertDialog(
      title: const Text("Delete Lineup?"),
      content: const Text("If you select delete then you will remove this lineup and its data! Do you want to continue?"),
      actions: [
        TextButton(
            onPressed: () {
              DBHelper().deleteLineup(id);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LineupPage()));
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
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLineupPage()));
            }),
        appBar: AppBar(
          title: const Text("Lineups"),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: "Home")));
              }),
          // actions: [
          // IconButton(
          //     onPressed: () {
          //       setState(() {
          //         editing = true;
          //       });
          //     },
          // icon: const Icon(Icons.edit))
          // ],
        ),
        body: Center(
            child: Column(
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
              future: DBHelper().getLineups(),
              builder: (context, snapshot) {
                if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                      shrinkWrap: true,
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
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => ShowLineupPage(lineup: snapshot.data![index])));
                          },
                        ));
                      }));
                } else {
                  return Center(
                    child: AlertDialog(
                      backgroundColor: const Color(0x997a7a7a),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      content: const Text("There are no lineups available, try adding a new one!"),
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
