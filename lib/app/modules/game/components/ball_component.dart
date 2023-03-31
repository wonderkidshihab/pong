import 'dart:developer';
import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:get/get.dart';
import 'package:pong/app/modules/game/components/player_component.dart';
import 'package:pong/app/modules/game/helper/limit_to_bound.dart';
import 'package:pong/app/modules/game/pong_game.dart';
import 'package:pong/app/modules/home/controllers/home_controller.dart';

class BallComponent extends PositionComponent
    with HasGameRef<PongGame>, CollisionCallbacks {
  BallComponent(Vector2 position, Vector2 size, this.image)
      : super(position: position) {
    this.size = size;
  }
  late Image image;
  SpriteComponent? ballSprite;

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(
      isSolid: true,
      radius: size.x / 2,
    ));
    ballSprite = SpriteComponent.fromImage(
      image,
      size: size,
      anchor: Anchor.topLeft,
    );
    add(
      ballSprite!,
    );
    anchor = Anchor.center;
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is PlayerComponent) {
      onPlayerCollision(other);
    } else if (other is ScreenHitbox) {
      onScreenCollision(intersectionPoints.first);
    } else {
      log('Hit: $other');
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  // This function is called when the ball collides with the player. It reverses the ball's
// speed on the x-axis and calls the increment function to increase the score by one.

  void onPlayerCollision(PositionComponent other) {
    var player = other as PlayerComponent;
    // depending on the side of the player, the ball will bounce in the opposite direction on the x-axis
    // and the y-axis speed will depend on the position of the ball in relation to the player
    // the closer the ball is to the center of the player, the faster it will bounce
    // the further away the ball is from the center of the player, the slower it will bounce
    // this is done by calculating the distance between the center of the player and the ball
    // get the hit position and subtract the half of the player's height
    // then divide the result by the player's height
    var hitPosition = (position.y) - (player.y + (player.height / 2));

    var hitPositionPercentage = hitPosition / player.height;

    Get.find<HomeController>().ballYSpeed.value = hitPositionPercentage * 5;

    Get.find<HomeController>().ballXSpeed.value = limitToBound(
        Get.find<HomeController>().ballXSpeed.value *= -1.25, -5, 5);
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
    angle += math.atan(ballYSpeed) * 5 * dt;
    super.update(dt);
  }

  void reset() {
    position = gameRef.size / 2;
    Get.find<HomeController>().ballXSpeed.value =
        math.Random().nextBool() ? 1 : -1 * (math.Random().nextDouble() + 1);
  }
}
