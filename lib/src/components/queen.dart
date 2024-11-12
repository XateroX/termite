/*
  Termite queen data class

*/
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:termite/src/abstract_clases/Entity.dart';
import 'package:termite/src/config.dart';
import 'package:termite/src/game_data_structures/hex.dart';
import 'package:termite/src/game_data_structures/queen.dart';
import 'package:termite/src/termite_game.dart';

import 'termite.dart';

class QueenComponent extends PositionComponent with HasGameReference<TermiteGame>{
  Queen queen;
  QueenComponent({
    required this.queen,
    required Vector2 position
    }) : super(position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Load textures, add children components, etc.
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw textures, canvas lines, etc.
    final paint = Paint()
      ..color = const Color(0xff1e6091)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, hexTileSize / 3, paint);
    // Add more custom rendering here
  }

  @override
  void update(double dt) {
    // based on frame rate
    super.update(dt);
    // Handle animations, moving parts, etc.
  }

  static QueenComponent fromTermiteEntity(Queen entity){
    return QueenComponent(queen: entity, position: entity.position);
  }
}
