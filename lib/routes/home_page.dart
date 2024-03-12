import 'package:eco_ninja/game.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../components/rounded_button.dart';

class HomePage extends Component with HasGameReference<MainRouterGame> {
  late final RoundedButton _button1;

  @override
  void onLoad() async {
    super.onLoad();

    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('game_music.mp3');

    add(
      _button1 = RoundedButton(
        text: "Play",
        onPressed: () {
          FlameAudio.play('click.wav');
          game.router.pushNamed('level-page');
        },
        color: Colors.blue,
        borderColor: Colors.white,
      ),
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // button in center of page
    _button1.position = size / 2;
  }
}
