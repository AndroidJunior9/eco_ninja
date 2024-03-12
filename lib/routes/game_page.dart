import 'dart:math';

import 'package:eco_ninja/components/pause_button.dart';
import 'package:eco_ninja/config/app_config.dart';
import 'package:eco_ninja/game.dart';
import 'package:eco_ninja/models/level_model.dart';
import 'package:eco_ninja/models/objective.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:eco_ninja/components/back_button.dart';
import 'package:flame_audio/flame_audio.dart';
import '../components/hazard_component.dart';

class GamePage extends Component
    with DragCallbacks, HasGameReference<MainRouterGame> {
  final Random random = Random();
  late List<double> hazardstime;
  late double time, countDown;
  late double max_time;
  late int no_of_hazard;
  TextComponent? _countdownTextComponent,
      _scoreTextComponent,
      _timeTextComponent;
  bool _countdownFinished = false;
  late LevelModel level;
  late int score, target;
  late List<Objective> remainingObjectives;

  @override
  void onMount() {
    super.onMount();
    level = game.selectedLevel!;
    // Reset game state

    max_time = level.timeLimit;
    no_of_hazard = level.noOfHazard;
    hazardstime = [];
    countDown = 3;
    score = 0;
    time = 0;
    _timeTextComponent?.text = max_time.toInt().toString();

    _countdownFinished = false;

    double initTime = 0; // Adjust this formula as needed
    double timeBetweenHazards = max_time / no_of_hazard;
    for (int i = 0; i < no_of_hazard; i++) {
      if (i != 0) {
        initTime = hazardstime.last;
      }

      final componentTime = timeBetweenHazards + initTime;
      hazardstime.add(componentTime);
    }

    addAll([
      BackButton(onPressed: () {
        FlameAudio.play('click.wav');
        game.router.pop();
      }),
      PauseButton(),
      _countdownTextComponent = TextComponent(
        text: '${countDown.toInt() + 1}',
        size: Vector2.all(50),
        position: game.size / 2,
        anchor: Anchor.center,
      ),
      _scoreTextComponent = TextComponent(
        text: 'Score: $score',
        position: Vector2(game.size.x - 10, 10),
        anchor: Anchor.topRight,
      ),
    ]);

    add(_timeTextComponent = TextComponent(
      text: _timeTextComponent?.text,
      position: Vector2(game.size.x / 2, 40),
      anchor: Anchor.center,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_countdownFinished) {
      countDown -= dt;

      _countdownTextComponent?.text = (countDown.toInt() + 1).toString();
      if (countDown < 0) {
        _countdownFinished = true;
      }
    } else {
      _countdownTextComponent?.removeFromParent();

      time += dt;

      _timeTextComponent?.text = '${max_time.toInt() - time.toInt()}';

      if (time >= max_time) {
        gameWon();
      }

      hazardstime
          .where((element) => element < time)
          .toList()
          .forEach((element) {
        final gameSize = game.size;

        double posX = random.nextInt(gameSize.x.toInt()).toDouble();

        Vector2 hazardposition = Vector2(posX, gameSize.y);
        Vector2 velocity = Vector2(0, game.maxVerticalVelocity);

        final randHazard = game.hazards.random();

        FlameAudio.play('hazard_spawn.wav');

        add(HazardComponent(
          this,
          hazardposition,
          acceleration: AppConfig.acceleration,
          hazard: randHazard,
          size: AppConfig.shapeSize,
          image: game.images.fromCache(randHazard.image),
          pageSize: gameSize,
          velocity: velocity,
        ));
        hazardstime.remove(element);
      });
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    componentsAtPoint(event.canvasStartPosition).forEach((element) {
      if (element is HazardComponent) {
        if (element.canDragOnShape) {
          element.touchAtPoint(event.canvasStartPosition);
        }
      }
    });
  }

  void gameOver() {
    game.router.pushNamed('game-over');
  }

  void gameWon() {
    print("Game Won");
    game.router.pushNamed('game-won');
  }

  void addScore() {
    score++;
    _scoreTextComponent?.text = 'Score: $score';
  }
}
