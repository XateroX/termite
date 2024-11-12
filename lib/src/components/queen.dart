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

class QueenComponent extends CircleComponent {
  Queen queen;
  QueenComponent({
    required this.queen,
    required super.position
    }) : super(
            radius: hexTileSize/3,
            anchor: Anchor.center,
            paint: Paint()
              ..color = const Color(0xff1e6091)
              ..style = PaintingStyle.fill,
            children: [CircleHitbox()]);

  static QueenComponent fromTermiteEntity(Queen entity){
    return QueenComponent(queen: entity, position: entity.position);
  }
}
