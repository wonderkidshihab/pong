import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:pong/app/modules/game/components/player_component.dart';
import 'package:pong/app/modules/game/pong_game.dart';
import 'package:pong/app/modules/home/controllers/home_controller.dart';

class BallComponent extends CircleComponent
    with HasGameRef<PongGame>, CollisionCallbacks {
  BallComponent(Vector2 position, Vector2 size) : super(position: position) {
    this.size = size;
    paint = Paint()..color = const Color(0xFFFFFFFF);
  }

  @override
  Future<void> onLoad() {
    add(CircleHitbox(
      isSolid: true,
      radius: size.x / 2,
    ));
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is PlayerComponent) {
      onPlayerCollision();
    } else if (other is ScreenHitbox) {
      onScreenCollision(intersectionPoints.first);
    } else {
      log('Hit: $other');
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  // This function is called when the ball collides with the player. It reverses the ball's
// speed on the x-axis and calls the increment function to increase the score by one.

  void onPlayerCollision() {
    Get.find<HomeController>().ballXSpeed.value *= -1;
  }

  /*
  This function checks the position of the ball in relation to the edges of the screen.
  If the ball hits any of the edges, it bounces off.
*/

  void onScreenCollision(Vector2 point) {
    if (point.x == 0) {
      gameRef.reset();
      Get.find<HomeController>().playerLeftScore.value++;
    } else if (point.x == gameRef.size.x) {
      gameRef.reset();
      Get.find<HomeController>().playerRightScore.value++;
    } else if (point.y == 0) {
      Get.find<HomeController>().ballYSpeed.value *= -1;
    } else if (point.y == gameRef.size.y) {
      Get.find<HomeController>().ballYSpeed.value *= -1;
    }
  }

  @override
  void update(double dt) {
    final ballXSpeed = Get.find<HomeController>().ballXSpeed.value * dt * 100;
    final ballYSpeed = Get.find<HomeController>().ballYSpeed.value * dt * 100;
    position += Vector2(ballXSpeed, ballYSpeed);
    super.update(dt);
  }

  void reset() {
    position = gameRef.size / 2;
  }
}
