/*
  Termite queen data class

*/
import 'package:termite/src/abstract_clases/Entity.dart';
import 'package:termite/src/game_data_structures/hex.dart';
import 'package:termite/src/termite_game.dart';

import 'termite.dart';

class Queen extends Entity {
  TermiteGame game;
  Hex myTile;

  Queen(this.game, this.myTile);

  bool generateMite() {
    try {
      var newTermite = Termite();

      // get all the adjacent tiles and see if any have space for the mite
      List<Hex> adjTiles = myTile.neighbors();
      for (Hex tile in adjTiles) {
        if (!tile.containsMite()) {
          tile.addEntity(newTermite);
          break;
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
