import 'package:flutter/material.dart';

extension PokemonGradientExtension on String? {
  LinearGradient toPokemonGradient() {
    final Map<String, List<Color>> pokemonGradients = {
      "green": [Color(0xFF48D0B0), Color(0xFF3CB08E)],
      "red": [Color(0xFFFB6C6C), Color(0xFFE55B5B)],
      "blue": [Color(0xFF76BEFE), Color(0xFF5AA6E6)],
      "yellow": [Color(0xFFFAE078), Color(0xFFE5C45B)],
      "black": [Color(0xFF333333), Color(0xFF1A1A1A)],
      "brown": [Color(0xFFB1736C), Color(0xFF9A5C55)],
      "gray": [Color(0xFFB8B8B8), Color(0xFF9E9E9E)],
      "pink": [Color(0xFFEE99AC), Color(0xFFD97C90)],
      "purple": [Color(0xFF9E6FCB), Color(0xFF7F52A8)],
      "white": [Color(0xFFE0E0E0), Color(0xFFBDBDBD)],
    };

    final colors = pokemonGradients[this?.toLowerCase() ?? ""] ?? [Colors.grey.shade300, Colors.grey.shade500];

    return LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight);
  }
}
