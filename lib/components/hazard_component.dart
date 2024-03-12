import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/image_composition.dart' as composition;
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../config/utils.dart';
import '../models/hazard_model.dart';
import '../routes/game_page.dart';

class HazardComponent extends SpriteComponent {
  Vector2 velocity;
  final Vector2 pageSize;
  final double acceleration;
  final HazardModel hazard;
  final composition.Image image;
  late Vector2 _initPosition;
  bool canDragOnShape = false;
  GamePage parentComponent;
  bool divided;

  HazardComponent(
    this.parentComponent,
    Vector2 p, {
    super.size,
    required this.velocity,
    required this.acceleration,
    required this.pageSize,
    required this.image,
    required this.hazard,
    super.angle,
    Anchor? anchor,
    this.divided = false,
  }) : super(
          sprite: Sprite(image),
          position: p,
          anchor: anchor ?? Anchor.center,
        ) {
    _initPosition = p;
    canDragOnShape = false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_initPosition.distanceTo(position) > 60) {
      canDragOnShape = true;
    }
    angle += .5 * dt;
    angle %= 2 * pi;

    position += Vector2(
        velocity.x, -(velocity.y * dt - .5 * AppConfig.gravity * dt * dt));

    velocity.y += (AppConfig.acceleration + AppConfig.gravity) * dt;

    if ((position.y - AppConfig.objsize) > pageSize.y) {
      removeFromParent();

      if (!divided && !hazard.isBomb) {
        parentComponent.gameOver();
      }
    }
  }

  void touchAtPoint(Vector2 vector2) {
    if (divided && !canDragOnShape) {
      return;
    }
    if (hazard.isBomb) {
      parentComponent.gameOver();
      return;
    }

    // angleOfTouchPoint
    FlameAudio.play('slicing_sound.mp3');
    final a = Utils.getAngleOfTouchPont(
        center: position, initAngle: angle, touch: vector2);

    if (a < 45 || (a > 135 && a < 225) || a > 315) {
      final dividedImage1 = composition.ImageComposition()
            ..add(image, Vector2(0, 0),
                source: Rect.fromLTWH(
                    0, 0, image.width.toDouble(), image.height / 2)),
          dividedImage2 = composition.ImageComposition()
            ..add(image, Vector2(0, 0),
                source: Rect.fromLTWH(0, image.height / 2,
                    image.width.toDouble(), image.height / 2));

      parentComponent.addAll([
        HazardComponent(
          parentComponent,
          center - Vector2(size.x / 2 * cos(angle), size.x / 2 * sin(angle)),
          hazard: hazard,
          image: dividedImage2.composeSync(),
          acceleration: acceleration,
          velocity: Vector2(velocity.x - 2, velocity.y),
          pageSize: pageSize,
          divided: true,
          size: Vector2(size.x, size.y / 2),
          angle: angle,
          anchor: Anchor.topLeft,
        ),
        HazardComponent(
          parentComponent,
          center +
              Vector2(size.x / 4 * cos(angle + 3 * pi / 2),
                  size.x / 4 * sin(angle + 3 * pi / 2)),
          size: Vector2(size.x, size.y / 2),
          angle: angle,
          anchor: Anchor.center,
          hazard: hazard,
          image: dividedImage1.composeSync(),
          acceleration: acceleration,
          velocity: Vector2(velocity.x + 2, velocity.y),
          pageSize: pageSize,
          divided: true,
        )
      ]);
    } else {
      // split image
      final dividedImage1 = composition.ImageComposition()
            ..add(image, Vector2(0, 0),
                source: Rect.fromLTWH(
                    0, 0, image.width / 2, image.height.toDouble())),
          dividedImage2 = composition.ImageComposition()
            ..add(image, Vector2(0, 0),
                source: Rect.fromLTWH(image.width / 2, 0, image.width / 2,
                    image.height.toDouble()));

      parentComponent.addAll([
        HazardComponent(
          parentComponent,
          center - Vector2(size.x / 4 * cos(angle), size.x / 4 * sin(angle)),
          size: Vector2(size.x / 2, size.y),
          angle: angle,
          anchor: Anchor.center,
          hazard: hazard,
          image: dividedImage1.composeSync(),
          acceleration: acceleration,
          velocity: Vector2(velocity.x - 2, velocity.y),
          pageSize: pageSize,
          divided: true,
        ),
        HazardComponent(
          parentComponent,
          center +
              Vector2(size.x / 2 * cos(angle + 3 * pi / 2),
                  size.x / 2 * sin(angle + 3 * pi / 2)),
          size: Vector2(size.x / 2, size.y),
          angle: angle,
          anchor: Anchor.topLeft,
          hazard: hazard,
          image: dividedImage2.composeSync(),
          acceleration: acceleration,
          velocity: Vector2(velocity.x + 2, velocity.y),
          pageSize: pageSize,
          divided: true,
        )
      ]);
    }

    parentComponent.addScore();

    removeFromParent();
  }
}
