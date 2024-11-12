import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:termite/src/termite_game.dart';
import 'package:termite/src/widgets/debugging_widgets/DebugTooling.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final TermiteGame game;

  @override
  void initState() {
    super.initState();
    game = TermiteGame();
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: game,
      overlayBuilderMap: {
        'debugTools': (BuildContext context, Game game) {
          return DebugTooling(game as TermiteGame);
        },
      },
    );
  }
}
