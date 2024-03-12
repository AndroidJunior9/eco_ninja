import 'package:eco_ninja/game.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'simple_button.dart';

class PauseButton extends SimpleButton with HasGameReference<MainRouterGame> {
  PauseButton({VoidCallback? onPressed})
      : super(
          Path()
            ..moveTo(14, 10)
            ..lineTo(14, 30)
            ..moveTo(26, 10)
            ..lineTo(26, 30),
          position: Vector2(60, 10),
        ) {
    super.action = onPressed ??
        () {
          FlameAudio.play('click.wav');
          game.router.pushNamed('pause');
        };
  }
}
