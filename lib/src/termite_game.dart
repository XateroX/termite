import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:termite/src/widgets/hex_constructor.dart';

import 'components/components.dart';
import 'config.dart';

class TermiteGame extends FlameGame with HasCollisionDetection, KeyboardEvents, TapDetector {
  TermiteGame()
      : super(
          camera: CameraComponent(),
        );

  double get width => size.x;
  double get height => size.y;
  HexGrid hexGrid = HexGrid(100, 100);
  Rect? previousVisibleRect;

  bool moveLeft = false;
  bool moveUp = false;
  bool moveRight = false;
  bool moveDown = false;

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
    debugText = TextComponent(
      text: '',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      position: Vector2(10, 10), // Position it at the top-left corner
    );
    add(debugText);
    // debugMode = true;
  }

  void addVisibleTiles() {
    final buffer = 100.0; // Buffer to render tiles outside the camera view
    final extendedRect = camera.visibleWorldRect.inflate(buffer);

    world.children.whereType<HexTile>().forEach((tile) {
      if (!extendedRect.overlaps(tile.toRect())) {
        tile.removeFromParent();
      }
    });

    for (final tile in hexGrid.grid) {
      if (extendedRect.overlaps(tile.toRect()) && !world.children.contains(tile)) {
        world.add(tile);
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
    debugText.text = 'moveRight'+moveRight.toString()+' moveLeft'+moveLeft.toString()+' moveUp'+moveUp.toString()+' moveDown'+moveDown.toString();
    if (moveRight) {
      camera.moveBy(Vector2(500 * dt, 0), speed: 500);
    }
    if (moveDown) {
      camera.moveBy(Vector2(0, 500 * dt), speed: 500);
    }
  }

  // Keyboard events to pan the camera
  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
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