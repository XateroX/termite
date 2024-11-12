import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:termite/src/game_data_structures/termite.dart';
import 'package:termite/src/termite_game.dart';

class DebugButtonAddMite extends StatelessWidget {
  final TermiteGame game;

  DebugButtonAddMite(this.game);

  @override
  build(BuildContext) {
    return ElevatedButton(
        onPressed: () => {game.queen?.generateMite()},
        child: Text("Add Termite"));
  }
}
