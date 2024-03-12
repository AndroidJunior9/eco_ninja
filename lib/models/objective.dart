import 'package:eco_ninja/models/objective_type.dart';

class Objective {
  final String description;
  final int value;
  final ObjectiveType type;

  Objective(
      {required this.description, required this.value, required this.type});
}
