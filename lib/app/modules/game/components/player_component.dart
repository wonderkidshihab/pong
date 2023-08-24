import 'dart:async';
import 'dart:math' show Random;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:pong/app/modules/game/components/ball_component.dart';
import 'package:pong/app/modules/game/helper/limit_to_bound.dart';
import 'package:pong/app/modules/game/pong_game.dart';

class PlayerComponent extends PositionComponent
    with HasGameRef<PongGame>, DragCallbacks, CollisionCallbacks {
  double playerXPosition;
  bool isAIPlayer = false;
  late Image image;
  PlayerComponent(
      {this.playerXPosition = 20,
      this.isAIPlayer = false,
      required this.image});
  int randomOffset =
      Random().nextInt(100) - 80 * (Random().nextBool() ? 1 : -1);

  @override
  FutureOr<void> onLoad() async {
    width = 20;
    height = 100;
    x = playerXPosition;
    y = gameRef.size.y / 2 - height / 2;
    size = Vector2(width, height);
    add(RectangleHitbox(size: Vector2(width, height)));
    add(SpriteComponent.fromImage(image, size: size));
    return super.onLoad();
  }

  @override
  void onDragStart(DragStartEvent event) {
    y = event.canvasPosition.yy.y - height / 2;
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    y = limitToBound(
        event.canvasPosition.yy.y - height / 2, 0, gameRef.size.y - height);

    super.onDragUpdate(event);
  }

  @override
  void update(double dt) {
    if (isAIPlayer) {
      // AI Player
      // Get the ball position from the gameref and move the player to the ball
      // position but with a random offset to make it more interesting
      final ballPosition = gameRef.ballComponent.position;
      y = limitToBound(
          ballPosition.y + randomOffset, 0, gameRef.size.y - height);
    }
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is BallComponent && !isAIPlayer) {
      reset();
    }
    super.onCollision(intersectionPoints, other);
  }

  void reset() {
    randomOffset = (Random().nextInt(size.y.floor()) -
            gameRef.ballComponent.size.y.floor()) *
        (-1);
  }
}
