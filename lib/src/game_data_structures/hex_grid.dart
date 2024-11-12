import 'dart:math';

import 'package:flame/components.dart';

import '../config.dart';

import '../components/hex_tile.dart';

import '../game_data_structures/hex.dart';

class HexGrid {
  List<Hex> grid = [];
  late int gridWidth;
  late int gridHeight;

  final Random random = Random();

/*
  Generate a HexGrid with the given number of columns and rows and 
  potentially with a starting HexGrid to re-generate the grid within. 
*/
  HexGrid(columns, rows) {
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

  Hex? getTile(int q, int r) {
    try {
      // find the tile in the list with q = q and r = r
      for (Hex tile in grid) {
        if (tile.q == q && tile.r == r) {
          return tile;
          break;
        }
      }
      return null;
    } catch (e) {
      print("Error in HexGrid while getting tile q:$q r:$r : ${e.toString()}");
      return null;
    }
  }

  Hex getRandomHex() {
    var q = random.nextInt(gridWidth);
    var r = random.nextInt(gridHeight);

    // this should not be null as we picked within the bounds of the whole grid
    return getTile(q, r)!;
  }
}
