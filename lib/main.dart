import 'package:eco_ninja/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart' hide Game;
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(GameWidget(game: MainRouterGame()));
}
