import 'package:flutter/material.dart';
import 'package:geloris/game.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/Geloris.png'), // 背景画像のパスを指定
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TetrisGame()),
                  );
                },
                child: const Text(
                  'Start Game 🤮',
                  style: TextStyle(
                      fontSize: 24, color: Color.fromARGB(255, 83, 33, 12)),
                ),
              ),
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}
