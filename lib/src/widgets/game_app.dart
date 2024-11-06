import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:termite/src/termite_game.dart';

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
    return const Placeholder();   
  }
}