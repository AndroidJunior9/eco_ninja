import 'package:eco_ninja/components/back_button.dart';
import 'package:eco_ninja/components/level_card.dart';
import 'package:eco_ninja/game.dart';
import 'package:eco_ninja/models/level_model.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart' hide BackButton;

class LevelPage extends Component with HasGameReference<MainRouterGame> {
  final List<LevelModel> levels;

  LevelPage({required this.levels});

  @override
  void onLoad() async {
    super.onLoad();

    add(BackButton(onPressed: () {
      FlameAudio.play('click.wav');
      game.router.pop();
    }));

    for (var i = 0; i < levels.length; i++) {
      var level = levels[i];
      add(LevelCard(
        levelName: level.name,
        onPressed: () {
          // Pass the level to the game page
          FlameAudio.play('click.wav');
          game.selectedLevel = level;
          game.router.pushNamed('game-page');
        },
        color: Colors.blueGrey.withOpacity(0.3),
        borderColor: Colors.grey.shade500,
      )
            ..x = game.size.x / 6 * (i + 1) // center horizontally
            ..y = 100 // center horizontally
          // Adjust the position of each card
          );
    }
  }
}
