import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:termite/src/abstract_clases/Entity.dart';
import 'package:termite/src/components/hex_tile.dart';
import 'package:termite/src/game_data_structures/hex.dart';
import 'package:termite/src/game_data_structures/queen.dart';
import 'package:termite/src/game_data_structures/termite.dart';
import 'package:termite/src/utils/calculations.dart';

import 'components/components.dart';

import 'game_data_structures/hex_grid.dart';

import 'config.dart';

class TermiteGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapDetector {
  TermiteGame()
      : super(
          camera: CameraComponent(),
        );

  double get width => size.x;
  double get height => size.y;
  HexGrid hexGrid = HexGrid(100, 100);
  late Queen? queen;
  Rect? previousVisibleRect;

  bool moveLeft = false;
  bool moveUp = false;
  bool moveRight = false;
  bool moveDown = false;

  // Set to keep track of visible tiles
  Set<HexTile> visibleTiles = {};

  Set<LogicalKeyboardKey> keysPressed = {};

  late TextComponent debugText = TextComponent(
    text: 'Test',
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    ),
    position: Vector2(100, 100),
  );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;
    // Initialize the debug text component
    // debugText = TextComponent(
    //   text: '',
    //   textRenderer: TextPaint(
    //     style: const TextStyle(
    //       color: Colors.white,
    //       fontSize: 12,
    //     ),
    //   ),
    //   position: Vector2(10, 10), // Position it at the top-left corner
    // );
    // add(debugText);
    // debugMode = true;

    Hex queenhex = hexGrid.getRandomHex();

    // make new queen
    queen = Queen(this, queenhex);
    queenhex.addEntity(queen!);

    this.overlays.add('debugTools');
  }

  void addVisibleTiles() {
    final buffer = 200.0; // Buffer to render tiles outside the camera view
    final extendedRect = camera.visibleWorldRect.inflate(buffer);

    // Remove tiles that are no longer visible
    visibleTiles.removeWhere((tile) {
      if (!extendedRect.overlaps(tile.toRect())) {
        tile.removeFromParent();
        return true;
      }
      return false;
    });

    // Add tiles that are now visible
    for (final hex in hexGrid.grid) {
      Vector2 position = calculateHexPosition(hex.q, hex.r);
      final tileRect = Rect.fromLTWH(
        position.x,
        position.y,
        hexTileSize,
        hexTileSize,
      );

      if (extendedRect.overlaps(tileRect) &&
          !visibleTiles.any((tile) => tile.hex == hex)) {
        final tile = HexTile(hex);
        world.add(tile);
        visibleTiles.add(tile);

        // refactor this so that the entities are part of a seperate array not part of the tiles
        // add all the entities in the hex to the world (convert them to their components)
        for (Entity entity in hex.entityList) {
          if (entity.runtimeType is Termite) {
            final termite = classComponents[Termite]!(entity);
            world.add(termite);
          }
        }
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    final visibleRect = camera.visibleWorldRect;
    // if (previousVisibleRect == null || !previousVisibleRect!.overlaps(visibleRect)) {
    //   addVisibleTiles();
    //   previousVisibleRect = visibleRect;
    // }
    addVisibleTiles();

    if (moveLeft) {
      camera.moveBy(Vector2(-500 * dt, 0), speed: 500);
    }
    if (moveUp) {
      camera.moveBy(Vector2(0, -500 * dt), speed: 500);
    }
    debugText.text = 'moveRight' +
        moveRight.toString() +
        ' moveLeft' +
        moveLeft.toString() +
        ' moveUp' +
        moveUp.toString() +
        ' moveDown' +
        moveDown.toString();
    if (moveRight) {
      camera.moveBy(Vector2(500 * dt, 0), speed: 500);
    }
    if (moveDown) {
      camera.moveBy(Vector2(0, 500 * dt), speed: 500);
    }
  }

  // Keyboard events to pan the camera
  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    final isKeyDown = event is KeyDownEvent;

    if (isKeyDown) {
      this.keysPressed.add(event.logicalKey);
      print(event.logicalKey.toString() + ' pressed');
    } else {
      this.keysPressed.remove(event.logicalKey);
      print(event.logicalKey.toString() + ' released');
    }

    moveLeft = this.keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    moveUp = this.keysPressed.contains(LogicalKeyboardKey.arrowUp);
    moveRight = this.keysPressed.contains(LogicalKeyboardKey.arrowRight);
    moveDown = this.keysPressed.contains(LogicalKeyboardKey.arrowDown);

    return KeyEventResult.handled;
  }
}
