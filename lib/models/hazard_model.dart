import 'package:flutter/material.dart';

class HazardModel {
  String image;
  bool isBomb;
  Color color;

  HazardModel({
    required this.image,
    this.isBomb = false,
    this.color = Colors.transparent,
  });
}
