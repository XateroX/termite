import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:termite/src/abstract_clases/Entity.dart';
import 'package:termite/src/components/hex_tile.dart';
import 'package:termite/src/components/queen.dart';
import 'package:termite/src/components/termite.dart';
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
  HexGrid hexGrid = HexGrid(25, 25);
  List<Entity> entities = [];
  late Queen? queen;
  Rect? previousVisibleRect;

  bool moveLeft = false;
  bool moveUp = false;
  bool moveRight = false;
  bool moveDown = false;

  bool debug = true;

  // Set to keep track of visible tiles
  Set<HexTile> visibleTiles = {};

  // Set to keep track of visible termites
  Set<TermiteComponent> visibleTermites = {};

  // Set to keep track of visible termites
  Set<QueenComponent> visibleQueens = {};

  Set<LogicalKeyboardKey> keysPressed = {};

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
    addEntity(queen!);

    this.overlays.add('debugTools');
  }

  void addVisibleComponents() {
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

    // Remove tiles that are no longer visible
    visibleTermites.removeWhere((mite) {
      if (!extendedRect.overlaps(mite.toRect())) {
        mite.removeFromParent();
        return true;
      }
      return false;
    });

    // Remove tiles that are no longer visible
    visibleQueens.removeWhere((queen) {
      if (!extendedRect.overlaps(queen.toRect())) {
        queen.removeFromParent();
        return true;
      }
      return false;
    });

    // Add tiles that are now visible
    for (final hex in hexGrid.grid) {
      Vector2 position = calculateHexCenterPosition(hex.q, hex.r);
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
      }
    }

    // Generate new hexes if there are empty spaces
    generateNewHexes(extendedRect);

    // Add entities that are now visible
    for (Entity entity in entities) {
      Vector2 position = calculateHexCenterPosition(entity.currentHex.q, entity.currentHex.r);
      final entityRect = Rect.fromLTWH(
        position.x,
        position.y,
        hexTileSize,
        hexTileSize,
      );
      if (entity is Termite){
          if (extendedRect.overlaps(entityRect) &&
              !visibleTermites.any((mite) => mite.termite == entity)) {
            final TermiteComponent termiteComponent = EntityComponentMappings.getTermiteComponent(entity as Termite);
            world.add(termiteComponent);
            visibleTermites.add(termiteComponent);
          }
      } else if (entity is Queen){
          if (extendedRect.overlaps(entityRect) &&
              !visibleQueens.any((queen) => queen.queen == entity)) {
            final QueenComponent queenComponent = EntityComponentMappings.getQueenComponent(entity as Queen);
            world.add(queenComponent);
            visibleQueens.add(queenComponent);
          }
      }
    }
  }

  void generateNewHexes(Rect extendedRect) {
    // Define the range of q and r values to check
    final int minQ = (extendedRect.left / (hexTileSize/2)).floor();
    final int maxQ = (extendedRect.right / (hexTileSize/2)).ceil();
    final int minR = (extendedRect.top / ((3 / 4) * hexTileSize)).floor();
    final int maxR = (extendedRect.bottom / ((3 / 4) * hexTileSize)).ceil();

    for (int q = minQ; q <= maxQ; q++) {
      for (int r = minR; r <= maxR; r++) {
        if (!hexGrid.grid.any((hex) => hex.q == q && hex.r == r)) {
          // Generate a new hex and add it to the grid
          final newHex = Hex(hexGrid, q, r);
          hexGrid.grid.add(newHex);

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
            world.add(tile);
            visibleTiles.add(tile);
          }
        }
      }
    }
  }

  void addEntity(Entity entity) {
    entities.add(entity);
  }

  bool containsMite(int q, int r) {
    var mites = [];
    mites.addAll(entities);
    mites.removeWhere((entity) => entity.runtimeType != Termite);
    for (int i=0; i<mites.length; i++) {
      var some_mite = (mites.elementAt(i) as Termite);
      if (some_mite.currentHex.q == q && some_mite.currentHex.r == r) {
        return true;
      }else{
        continue;
      }
    }
    return false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    final visibleRect = camera.visibleWorldRect;
    addVisibleComponents();

    if (moveLeft) {
      camera.moveBy(Vector2(-500 * dt, 0), speed: 500);
    }
    if (moveUp) {
      camera.moveBy(Vector2(0, -500 * dt), speed: 500);
    }
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
      if (debug){
        // print(event.logicalKey.toString() + ' pressed');
      }
    } else {
      this.keysPressed.remove(event.logicalKey);
      if (debug){
        // print(event.logicalKey.toString() + ' released');
      }
    }
    

    moveLeft = this.keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    moveUp = this.keysPressed.contains(LogicalKeyboardKey.arrowUp);
    moveRight = this.keysPressed.contains(LogicalKeyboardKey.arrowRight);
    moveDown = this.keysPressed.contains(LogicalKeyboardKey.arrowDown);

    return KeyEventResult.handled;
  }
}