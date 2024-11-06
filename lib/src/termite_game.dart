import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';                             
import 'package:flame/game.dart';
import 'package:flutter/material.dart';                         
import 'package:flutter/services.dart'; 

import 'components/components.dart';
import 'config.dart';

enum PlayState { welcome, playing, gameOver, won }

class TermiteGame extends FlameGame with HasCollisionDetection, KeyboardEvents, TapDetector  {
  TermiteGame()
      : super(
            camera: CameraComponent(),
        );

  final ValueNotifier<int> score = ValueNotifier(0); 
  final rand = math.Random();  
  double get width => size.x;
  double get height => size.y;

  late PlayState _playState;                                    // Add from here...
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
        overlays.add(playState.name);
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());
    playState = PlayState.welcome;
  }

  void startGame() {
    debugMode = true;
  }         
}