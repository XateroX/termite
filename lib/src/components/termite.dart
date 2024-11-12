import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:termite/src/abstract_clases/Entity.dart';
import 'package:termite/src/config.dart';
import 'package:termite/src/game_data_structures/hex.dart';
import 'package:termite/src/game_data_structures/termite.dart';
import 'package:termite/src/termite_game.dart';

class TermiteComponent extends CircleComponent with HasGameReference<TermiteGame> {
  Termite termite; 
  TermiteComponent({
    required this.termite,
    required super.position,
    }) : super(
            radius: hexTileSize/3,
            anchor: Anchor.center,
            paint: Paint()
              ..color = const Color.fromARGB(255, 255, 0, 0)
              ..style = PaintingStyle.fill,
            children: [CircleHitbox()]);      
    // this is the constructor

  static TermiteComponent fromTermiteEntity(Termite entity){
    return TermiteComponent(termite: entity, position: entity.position);
  }
}
