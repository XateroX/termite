/*
  Termite queen data class

*/
import 'package:termite/src/abstract_clases/Entity.dart';
import 'package:termite/src/game_data_structures/hex.dart';
import 'package:termite/src/termite_game.dart';

import 'termite.dart';

class Queen extends Entity {
  TermiteGame game;

  Queen(this.game, Hex currentHex) : super(currentHex);

  bool generateMite() {
    try {
      // get all the adjacent tiles and see if any have space for the mite
      List<Hex> adjTiles = currentHex.neighbors();
      for (Hex tile in adjTiles) {
        if (!game.containsMite(tile.q, tile.r)) {
          var newTermite = Termite(tile);
          game.addEntity(newTermite);
          break;
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
