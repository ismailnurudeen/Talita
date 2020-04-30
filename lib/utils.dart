import 'package:flutter/material.dart';

class Utils {
  static DateTime getDateFromString(String dateString) => DateTime.parse(dateString);
}

class ColorRes {
  static const greenAccent = Color(0xFF69F0AE);
  static const richBlack = Color(0xFF042A2B);
  static const pacificBlue = Color(0xFF5eb1bf);
  static const florecentBlue = Color(0xFF54f2f2);
  static const babyPowder = Color(0xFFfcfcfc);
  static const cornYellow = Color(0xFFf6e654);
  static const lightCornYellow = Color(0xFFf7e864);
}

class ImageConfig {
  static const base_url = "http://image.tmdb.org/t/p/";
}

class PosterSizes {
  static const original = "original";
  static const w90 = "w90";
  static const w185 = "w185";
  static const w154 = "w154";
  static const w342 = "w342";
  static const w500 = "w500";
  static const w780 = "w780";
}