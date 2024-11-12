import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:termite/src/abstract_clases/Entity.dart';
import 'package:termite/src/game_data_structures/hex_grid.dart';
import 'package:termite/src/game_data_structures/termite.dart';
import 'package:termite/src/utils/calculations.dart';

import '../game_data_structures/hex.dart';

import '../config.dart';

class HexTile extends PositionComponent {
  List<Entity> entityList = [];
  late final int q;
  late final int r;
  Hex hex;

  HexTile(this.hex) {
    // calculate pixel position from hex and hexTileSize
    q = hex.q;
    r = hex.r;
    position = calculateHexPosition(q, r);
    size = Vector2(hexTileSize.toDouble(), hexTileSize.toDouble());
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
