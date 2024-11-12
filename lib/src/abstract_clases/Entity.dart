import 'package:flame/game.dart';
import 'package:termite/src/game_data_structures/hex.dart';
import 'package:termite/src/utils/calculations.dart';

class Entity {
  /*
    Basic class which can live inside tiles and be shown within them
  */
  Hex currentHex;
  Entity(this.currentHex);

  Vector2 get position => calculateHexCenterPosition(currentHex.q, currentHex.r);
}
