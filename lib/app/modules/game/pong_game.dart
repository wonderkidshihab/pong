import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:pong/app/modules/game/components/ball_component.dart';
import 'package:pong/app/modules/game/components/player_component.dart';
import 'package:pong/app/modules/game/components/score_component.dart';

class PongGame extends FlameGame
    with HasDraggableComponents, HasCollisionDetection {
  Vector2 ballPositon = Vector2(700, 500);
  late BallComponent ballComponent;
  late PlayerComponent playerComponent1;
  late PlayerComponent playerComponent2;

  @override
  FutureOr<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    await images.loadAll(<String>['ball.png', 'player.png', 'bg.jpg']);
    ballPositon = Vector2(size.x / 2, size.y / 2);
    ballComponent = BallComponent(
        ballPositon, Vector2(40, 40), images.fromCache('ball.png'));
    playerComponent1 = PlayerComponent(
        playerXPosition: 0,
        isAIPlayer: true,
        image: images.fromCache('player.png'));
    playerComponent2 = PlayerComponent(
        playerXPosition: size.x - 20, image: images.fromCache('player.png'));
    add(SpriteComponent.fromImage(
      images.fromCache('bg.jpg'),
      size: size,
    ));
    add(ballComponent);
    add(playerComponent1);
    add(playerComponent2);
    add(ScreenHitbox());
    add(ScoreComponent());
    return super.onLoad();
  }

  reset() {
    ballComponent.reset();
    playerComponent1.reset();
  }
}
