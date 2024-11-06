import 'dart:ffi';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:termite/src/termite_game.dart';

import '../config.dart';

class HexTile extends PositionComponent {
  HexTile(Vector2 position) {
    this.position = position;
    size = Vector2.all(hexTileSize);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Color.fromARGB(255, 0, 0, 0);
    final path = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(size.x, size.y / 4)
      ..lineTo(size.x, 3 * size.y / 4)
      ..lineTo(size.x / 2, size.y)
      ..lineTo(0, 3 * size.y / 4)
      ..lineTo(0, size.y / 4)
      ..close();
    canvas.drawPath(path, paint);

    final outlinePaint = Paint()
      ..color = Color.fromARGB(255, 0, 0, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(path, outlinePaint);
  }
}


class HexGrid {
  List<HexTile> grid = [];

/*
  Generate a HexGrid with the given number of columns and rows and 
  potentially with a starting HexGrid to re-generate the grid within. 
*/
  HexGrid(columns, rows) {
    _generateGrid(columns, rows);
  }

  void _generateGrid(int columns, int rows) {
    for (int i = 0; i < columns; i++) {
      for (var j = 0; j < rows; j++) {
        grid.add(HexTile(Vector2(i * hexTileSize + (j%2) * hexTileSize/2, (j*(3/4)) * hexTileSize)));
      }
    }
  }
}