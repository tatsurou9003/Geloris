import 'package:flutter/material.dart';
import 'package:geloris/game.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 136, 105, 3),
      appBar: AppBar(
        title: const Text('Geloris'),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TetrisGame()),
            );
          },
          child: const Text(
            'Start Game 🤮',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
