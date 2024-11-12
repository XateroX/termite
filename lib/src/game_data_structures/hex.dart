import 'package:termite/src/abstract_clases/Entity.dart';
import 'package:termite/src/game_data_structures/termite.dart';

class Hex {
  final parentHexGrid;
  final int q;
  final int r;

  Hex(this.parentHexGrid, this.q, this.r);

  List<Hex> neighbors() {
    // get all adjacent tiles in parentHexGrid and return them
    List<Hex?> adjacentTiles = [];
    adjacentTiles.add(parentHexGrid.getTile(q + 1, r));
    adjacentTiles.add(parentHexGrid.getTile(q - 1, r));
    adjacentTiles.add(parentHexGrid.getTile(q + 1, r + 1));
    adjacentTiles.add(parentHexGrid.getTile(q - 1, r + 1));
    adjacentTiles.add(parentHexGrid.getTile(q, r + 1));
    adjacentTiles.add(parentHexGrid.getTile(q, r - 1));

    return adjacentTiles.whereType<Hex>().toList();
  }

  @override
  int get hashCode => q.hashCode ^ r.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is Hex) {
      return q == other.q && r == other.r;
    }
    return false;
  }
}
