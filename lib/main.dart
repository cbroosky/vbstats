import 'package:flutter/material.dart';
import 'lineups.dart';
import "game.dart";
import 'players.dart';
import 'vbStatTheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VBStats',
      theme: CustomTheme.darkTheme,
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.home), onPressed: () {}),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                title: const Text(
                  "Players",
                  style: TextStyle(
                    // color: Color(0xfff0f8ff),
                    fontSize: 30,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PlayerPage()));
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text(
                  "Lineups",
                  style: TextStyle(
                    // color: Color(0xfff0f8ff),
                    fontSize: 30,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LineupPage()));
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text(
                  "Game",
                  style: TextStyle(
                    // color: Color(0xfff0f8ff),
                    fontSize: 30,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GamePage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
