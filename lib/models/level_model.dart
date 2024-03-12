import 'package:eco_ninja/models/objective.dart';

class LevelModel {
  final String name;
  final List<Objective> objectives;
  final double timeLimit;
  final int noOfHazard;

  LevelModel(
      {required this.name,
      required this.objectives,
      required this.timeLimit,
      required this.noOfHazard});
}
