import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/painting.dart';
import 'package:pong/app/modules/game/pong_game.dart';

class PlayerComponent extends PositionComponent
    with HasGameRef<PongGame>, DragCallbacks {
  double playerXPosition;
  PlayerComponent({this.playerXPosition = 20});

  @override
  FutureOr<void> onLoad() {
    width = 20;
    height = 100;
    x = playerXPosition;
    y = gameRef.size.y / 2 - height / 2;
    size = Vector2(width, height);
    add(RectangleHitbox(size: Vector2(width, height)));
    add(RectangleComponent(
        size: Vector2(width, height),
        paint: Paint()..color = const Color(0xFFFFFFFF)));
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
}

limitToBound(double value, double min, double max) {
  if (value < min) {
    return min;
  } else if (value > max) {
    return max;
  } else {
    return value;
  }
}
