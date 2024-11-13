import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:termite/src/abstract_clases/Entity.dart';
import 'package:termite/src/config.dart';
import 'package:termite/src/game_data_structures/hex.dart';
import 'package:termite/src/game_data_structures/termite.dart';
import 'package:termite/src/termite_game.dart';

class TermiteComponent extends PositionComponent with HasGameReference<TermiteGame> {
  Random random = Random();
  Termite termite; 
  double legMaxExtent = hexTileSize/3;
  Vector2 velocity = Vector2(0,0);
  List<Vector2> legPerfectPositions = [];
  List<Vector2> legTargetPositions = [];
  List<Vector2> legPositions = [];
  TermiteComponent({
    required this.termite,
    required Vector2 position,
    }) : super(
      position: position,
      ){
      velocity = Vector2(random.nextDouble() * 200 - 100, random.nextDouble() * 200 - 100);
      velocity = velocity.normalized() * 100;

      for (int i = 0; i < 6; i++){
        Vector2 newPosition = generateNewLegPosition(i);

        // initially set the leg position at the target
        Vector2 relativePosition = newPosition - position;
        legPerfectPositions.add(relativePosition);
        legTargetPositions.add(newPosition);
        legPositions.add(newPosition);
      }
    }
  
  Vector2 generateNewLegPosition(int legInd){
    // get the angle of the velocity vector
    double velocityAngle = atan2(velocity.y, velocity.x);

    // add this angle first to rotate the legs the right way
    double angle = (30 * 3.14159 / 180) + velocityAngle + (legInd * 60) * 3.14159 / 180;
    double x = hexTileSize / 2 * 0.4 * cos(angle);
    double y = hexTileSize / 2 * 0.4 * sin(angle);

    // // scale the leg position by a random amount
    // x *= 1+random.nextDouble();
    // y *= 1+random.nextDouble();

    // // add random jitter to the leg position
    // x += random.nextDouble() * 5;
    // y += random.nextDouble() * 5;

    // add the velocity to make the legs appear in the direction of motion
    // x += velocity.x*0.001;
    // y += velocity.y*0.001;

    // scale leg to right length
    Vector2 normalized = Vector2(x,y).normalized();
    x = normalized.x * legMaxExtent;
    y = normalized.y * legMaxExtent;
    

    // scale the overall vector at a right angle to the direction of motion
    // Vector2 directionOfMotion = velocity.normalized();
    // Vector2 rightAngleDirection = Vector2(-directionOfMotion.y, directionOfMotion.x);

    // try to make the leg vector point in the direction of motion
    // x += rightAngleDirection.x * 5;
    // y += rightAngleDirection.y * 5;

    // add the current position to the leg position
    x += position.x;
    y += position.y;

    return Vector2(x, y);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Load textures, add children components, etc.
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw textures, canvas lines, etc.
    final paint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill;
    paint.strokeWidth = 2;
    canvas.drawCircle(Offset.zero, hexTileSize / 8, paint);
    
    // render legs
    for (Vector2 legPosition in legPositions){
      // find the point that is equal distance from the body and the leg
      Vector2 middlePoint = (position + legPosition) / 2;

      // rotate this point by 45 degrees from the body if the leg is in the first half
      // of the body, and by -45 degrees if the leg is in the second half of the body
      bool firstHalf = legPositions.indexOf(legPosition) < (legPositions.length/2).ceil();
      double angle;
      if (firstHalf) {
        angle = -20 * 3.14159 / 180;
      } else {
        angle = 20 * 3.14159 / 180;
      }
      
      double x = middlePoint.x - position.x;
      double y = middlePoint.y - position.y;
      double xnew = x * cos(angle) - y * sin(angle);
      double ynew = x * sin(angle) + y * cos(angle);
      middlePoint = Vector2(xnew + position.x, ynew + position.y);

      // draw line from body to middle point
      canvas.drawLine(Offset.zero, Offset(middlePoint.x - position.x, middlePoint.y - position.y), paint);

      // draw line from middle point to leg
      canvas.drawLine(Offset(middlePoint.x - position.x, middlePoint.y - position.y), Offset(legPosition.x - position.x, legPosition.y - position.y), paint);

      // draw a foot
      canvas.drawRect(Rect.fromCenter(center: Offset(legPosition.x - position.x, legPosition.y - position.y), width: hexTileSize / 20, height: hexTileSize / 20), paint);

      

      // draw a circle at the middle point
      canvas.drawCircle(Offset(middlePoint.x - position.x, middlePoint.y - position.y), hexTileSize / 30, paint);

      // debug text for the index of the leg
      // final textPainter = TextPainter(
      //   text: TextSpan(
      //     text: legPositions.indexOf(legPosition).toString(),
      //     style: TextStyle(
      //       color: const Color(0xffffffff),
      //       fontSize: 12,
      //     ),
      //   ),
      //   textDirection: TextDirection.ltr,
      // );
      // textPainter.layout();
      // textPainter.paint(canvas, Offset(legPosition.x - position.x, legPosition.y - position.y));
    }

    // draw line in direction of velocity
    // get the angle of the velocity vector
    Paint velocityArrowPaint = Paint()
      ..color = const Color.fromARGB(255, 255, 0, 0)
      ..style = PaintingStyle.stroke;
    velocityArrowPaint.strokeWidth = 2;
    double velocityAngle = atan2(velocity.y, velocity.x);
    double x = hexTileSize / 2 * 0.6 * cos(velocityAngle);
    double y = hexTileSize / 2 * 0.6 * sin(velocityAngle);
    canvas.drawLine(Offset.zero, Offset(x, y), velocityArrowPaint);
  }

  @override
  void update(double dt) {
    // based on frame rate
    super.update(dt);
    // Handle animations, moving parts, etc.
    position += velocity * dt;

    // if any of the legs are too far from the body, generate new leg positions
    for (int i = 0; i < 6; i++){
      Vector2 legTargetPosition = legTargetPositions[i];
      Vector2 legPerfectPositionRelative = legPerfectPositions[i];

      legPerfectPositionRelative = legPerfectPositionRelative + position;

      double distance = legTargetPosition.distanceTo(legPerfectPositionRelative);
      if (distance > legMaxExtent/(1.5+i*legMaxExtent*0.01)){
        legTargetPositions[i] = generateNewLegPosition(i);
      }
    }

    // update all legs every frame to lerp towards their targets
    lerpLegsTowardsTargets(dt);
  }

  void lerpLegsTowardsTargets(dt){
    for (int i = 0; i < legTargetPositions.length; i++){
      Vector2 legTargetPosition = legTargetPositions[i];
      Vector2 legPosition = legPositions[i];
      Vector2 difference = legTargetPosition - legPosition;
      legPositions[i] += difference/1.01;
    }
  }

  static TermiteComponent fromTermiteEntity(Termite entity){
    return TermiteComponent(termite: entity, position: entity.position);
  }
}
