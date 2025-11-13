import 'package:ctbkio/models/category.dart';
import 'package:flutter/material.dart';

class Feature {
  final String title;
  final Color colorStart;
  final Color colorEnd;
  final IconData icon;
  final KioCategory category;
  const Feature(this.title, this.colorStart, this.colorEnd, this.icon, this.category);
}