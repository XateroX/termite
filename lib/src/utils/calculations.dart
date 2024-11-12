import 'dart:ffi';

import 'package:flame/game.dart';
import 'package:termite/src/config.dart';

Vector2 calculateHexPosition(int column, int row) {
  return Vector2(
    (column * hexTileSize + (row % 2) * hexTileSize / 2).toDouble(),
    (row * (3 / 4) * hexTileSize).toDouble(),
  );
}
