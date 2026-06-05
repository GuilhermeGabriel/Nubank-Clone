import 'package:flutter/material.dart';

abstract class AppColors {
  static const primary = Color.fromARGB(255, 131, 10, 209);
  static const secondary = Color.fromARGB(255, 144, 40, 215);
  static const text = Color.fromARGB(255, 25, 25, 25);
  static const secondaryText = Color.fromARGB(255, 115, 115, 115);
  static const invoice = Color.fromARGB(255, 38, 161, 221);
  static const nextInvoice = Color.fromARGB(255, 255, 120, 62);
  static const limit = Color.fromARGB(255, 35, 125, 70);
  static const unview = Color.fromARGB(255, 245, 245, 245);
  static const line = Color.fromARGB(255, 204, 204, 204);
  static const labelButton = Color.fromARGB(255, 240, 241, 245);

  // ----- Cores do dark mode -----
  static const darkBackground = Color.fromARGB(255, 0, 0, 0);
  static const darkSurface = Color.fromARGB(255, 28, 28, 30);

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// Fundo principal das telas (branco / preto).
  static Color background(BuildContext context) =>
      isDark(context) ? darkBackground : const Color(0xFFFFFFFF);

  /// Superfície de cards e botões secundários (cinza claro / cinza escuro).
  static Color surface(BuildContext context) =>
      isDark(context) ? darkSurface : labelButton;

  /// Cor de conteúdo/texto principal (escuro / branco).
  static Color content(BuildContext context) =>
      isDark(context) ? const Color(0xFFFFFFFF) : text;
}
