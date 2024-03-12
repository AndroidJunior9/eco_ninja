import 'dart:math';

import 'package:eco_ninja/config/app_config.dart';
import 'package:eco_ninja/models/hazard_model.dart';
import 'package:eco_ninja/models/level_model.dart';
import 'package:eco_ninja/routes/game_over_page.dart';
import 'package:eco_ninja/routes/game_page.dart';
import 'package:eco_ninja/routes/game_won_page.dart';
import 'package:eco_ninja/routes/home_page.dart';
import 'package:eco_ninja/routes/level_page.dart';
import 'package:eco_ninja/routes/pause_game.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';

class MainRouterGame extends FlameGame {
  late final RouterComponent router;
  late double maxVerticalVelocity;

  LevelModel? selectedLevel;

  final List<HazardModel> hazards = [
    HazardModel(image: "bottle.png"),
  ];

  final List<LevelModel> levels = [
    LevelModel(name: "Level 1", objectives: [], timeLimit: 30, noOfHazard: 20),
    LevelModel(name: "Level 2", objectives: [], timeLimit: 30, noOfHazard: 25),
    LevelModel(name: "Level 3", objectives: [], timeLimit: 30, noOfHazard: 30),
    LevelModel(name: "Level 4", objectives: [], timeLimit: 45, noOfHazard: 40),
    LevelModel(name: "Level 5", objectives: [], timeLimit: 60, noOfHazard: 60)
  ];

  @override
  void onLoad() async {
    super.onLoad();

    for (final hazard in hazards) {
      await images.load(hazard.image);
    }

    addAll([
      ParallaxComponent(
          parallax: Parallax(
              [await ParallaxLayer.load(ParallaxImageData('background.png'))])),
      router = RouterComponent(initialRoute: 'home', routes: {
        'home': Route(HomePage.new),
        'game-page': Route(GamePage.new),
        'pause': PauseRoute(),
        'game-over': GameOverRoute(),
        'game-won': GameWonRoute(),
        'level-page': Route(() => LevelPage(levels: levels)),
      })
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    getMaxVerticalVelocity(size);
  }

  void getMaxVerticalVelocity(Vector2 size) {
    maxVerticalVelocity = sqrt(2 *
        (AppConfig.gravity.abs() + AppConfig.acceleration.abs()) *
        (size.y - AppConfig.objsize * 2));
  }
}
