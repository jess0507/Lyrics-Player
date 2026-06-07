import 'package:flutter/material.dart';

/// 可供使用者選擇的主題種子色。
///
/// 參考 Flutter 官方 material_3_demo 的 `ColorSeed`：每個種子色經
/// [ColorScheme.fromSeed] 推導出完整的 Material 3 配色。
enum AppColorSeed {
  indigo('Indigo', Color(0xFF3D5AFE)),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink),
  purple('Purple', Colors.purple);

  const AppColorSeed(this.label, this.color);

  final String label;
  final Color color;

  /// 預設種子色（沿用改版前的藍色）。
  static const AppColorSeed defaultSeed = AppColorSeed.indigo;

  static AppColorSeed fromName(String? name) {
    return values.firstWhere(
      (s) => s.name == name,
      orElse: () => defaultSeed,
    );
  }
}

/// 集中管理深 / 淺色主題。
class AppTheme {
  AppTheme._();

  static ThemeData light(AppColorSeed seed) =>
      _build(Brightness.light, seed.color);
  static ThemeData dark(AppColorSeed seed) =>
      _build(Brightness.dark, seed.color);

  static ThemeData _build(Brightness brightness, Color seed) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }
}
