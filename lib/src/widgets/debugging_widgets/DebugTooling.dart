import 'package:flutter/material.dart';
import 'package:termite/src/config.dart';
import 'package:termite/src/termite_game.dart';
import 'package:termite/src/widgets/debugging_widgets/DebugButtonAddMite.dart';

class DebugTooling extends StatelessWidget {
  final TermiteGame game;
  DebugTooling(this.game);

  @override
  Widget build(BuildContext context) {
    // var to store if the debug tools are open or closed
    bool isOpen = false;

    // construct a column on the left side of the screen which is opened and closed by a button
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isOpen = !isOpen;
                });
              },
              child: const Text('Click me!'),
            ),
            if (isOpen)
              Container(
                width: gameWidth / 3,
                color: Colors.white,
                child: Column(
                  children: [DebugButtonAddMite(game)],
                ),
              ),
          ],
        );
      },
    );
  }
}
