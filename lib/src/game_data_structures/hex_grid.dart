import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:termite/src/termite_game.dart';
import 'package:termite/src/utils/calculations.dart';

import '../config.dart';

import '../components/hex_tile.dart';

import '../game_data_structures/hex.dart';

class HexGrid {
  final TermiteGame game;

  List<Hex> grid = [];
  late int gridWidth;
  late int gridHeight;

  final Random random = Random();

/*
  Generate a HexGrid with the given number of columns and rows and 
  potentially with a starting HexGrid to re-generate the grid within. 
*/
  HexGrid(this.game, columns, rows) {
    gridWidth = columns;
    gridHeight = rows;
    _generateGrid(columns, rows);
  }

  void _generateGrid(int columns, int rows) {
    for (int i = 0; i < columns; i++) {
      for (var j = 0; j < rows; j++) {
        var hex = Hex(this, i, j);
        grid.add(hex);
      }
    }
  }

  Hex getTile(int q, int r) {
    // find the tile in the list with q = q and r = r
    for (Hex tile in grid) {
      if (tile.q == q && tile.r == r) {
        return tile;
      }
    }

    // no tile exists for the given q and r, so generate new tiles around the given q and r
    generateNewHexesByCoords(q, r, 5);

    // now that we have generated the new tiles, try to find the tile again
    for (Hex tile in grid) {
      if (tile.q == q && tile.r == r) {
        return tile;
      }
    }

    // If the tile is still not found, throw an exception (this should never happen)
    throw Exception('Tile not found after generating new hexes');
  }

  Hex getRandomHex() {
    var q = random.nextInt(gridWidth);
    var r = random.nextInt(gridHeight);

    // this should not be null as we picked within the bounds of the whole grid
    return getTile(q, r)!;
  }

  void generateNewHexes(Rect extendedRect) {
    // Define the range of q and r values to check
    final int minQ = (extendedRect.left / (hexTileSize/2)).floor();
    final int maxQ = (extendedRect.right / (hexTileSize/2)).ceil();
    final int minR = (extendedRect.top / ((3 / 4) * hexTileSize)).floor();
    final int maxR = (extendedRect.bottom / ((3 / 4) * hexTileSize)).ceil();

    for (int q = minQ; q <= maxQ; q++) {
      for (int r = minR; r <= maxR; r++) {
        if (!game.hexGrid.grid.any((hex) => hex.q == q && hex.r == r)) {
          // Generate a new hex and add it to the grid
          final newHex = Hex(this, q, r);
          grid.add(newHex);

          // Add the new hex to the visible tiles if it overlaps with the extendedRect
          Vector2 position = calculateHexCenterPosition(q, r);
          final tileRect = Rect.fromLTWH(
            position.x,
            position.y,
            hexTileSize,
            hexTileSize,
          );

          if (extendedRect.overlaps(tileRect)) {
            final tile = HexTile(newHex);
            game.world.add(tile);
            game.visibleTiles.add(tile);
          }
        }
      }
    }
  }

  void generateNewHexesByCoords(int q, int r, int buffer) {
    // using the coords generate tiles to fill around the target tile
    final int minQ = q - buffer;
    final int maxQ = q + buffer;
    final int minR = r - buffer;
    final int maxR = r + buffer;

    for (int q = minQ; q <= maxQ; q++) {
      for (int r = minR; r <= maxR; r++) {
        if (!game.hexGrid.grid.any((hex) => hex.q == q && hex.r == r)) {
          // Generate a new hex and add it to the grid
          final newHex = Hex(this, q, r);
          grid.add(newHex);
        }
      }
    }
  }
}
