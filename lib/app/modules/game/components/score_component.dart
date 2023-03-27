import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:pong/app/modules/game/pong_game.dart';
import 'package:pong/app/modules/home/controllers/home_controller.dart';

class ScoreComponent extends PositionComponent with HasGameRef<PongGame> {
  late TextPainter _painter;
  late TextStyle _textStyle;
  late Offset _position;

  ScoreComponent() {
    _painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    _textStyle = const TextStyle(
      color: Color(0xFFFFFFFF),
      fontSize: 30.0,
    );
  }

  @override
  void render(Canvas canvas) {
    _painter.paint(canvas, _position);
  }

  @override
  void update(double dt) {
    _painter.text = TextSpan(
      text:
          "Left: ${Get.find<HomeController>().playerRightScore} Right: ${Get.find<HomeController>().playerLeftScore}",
      style: _textStyle,
    );

    _painter.layout();

    _position = Offset(
      (gameRef.size.x / 2) - (_painter.width / 2),
      (gameRef.size.y * 0.2) - (_painter.height / 2),
    );
  }
}
