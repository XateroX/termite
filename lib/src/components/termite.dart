import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:termite/src/abstract_clases/Entity.dart';
import 'package:termite/src/config.dart';
import 'package:termite/src/game_data_structures/hex.dart';
import 'package:termite/src/game_data_structures/termite.dart';
import 'package:termite/src/termite_game.dart';

class TermiteComponent extends PositionComponent with HasGameReference<TermiteGame> {
  Termite termite; 
  TermiteComponent({
    required this.termite,
    required Vector2 position,
    }) : super(position: position);      
    // this is the constructor

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
      ..color = const Color.fromARGB(255, 0, 255, 30)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, hexTileSize / 5, paint);
    // Add more custom rendering here
  }

  @override
  void update(double dt) {
    // based on frame rate
    super.update(dt);
    // Handle animations, moving parts, etc.
  }

  static TermiteComponent fromTermiteEntity(Termite entity){
    return TermiteComponent(termite: entity, position: entity.position);
  }
}
