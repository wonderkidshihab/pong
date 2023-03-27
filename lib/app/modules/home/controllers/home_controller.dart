import 'dart:math';

import 'package:get/get.dart';

class HomeController extends GetxController {
  final playerRightScore = 0.obs;
  final playerLeftScore = 0.obs;
  final acc = 0.1.obs;

  void increment() {
    playerRightScore.value++;
    ballXSpeed.value += acc.value;
    ballYSpeed.value += acc.value;
  }

  final ballXSpeed = 1.0.obs;
  final ballYSpeed = 1.0.obs;

  @override
  void onInit() {
    ballXSpeed.value = Random().nextBool() ? 1.0 : -1.0;
    ballYSpeed.value = Random().nextBool() ? 1.0 : -1.0;
    super.onInit();
  }
}
