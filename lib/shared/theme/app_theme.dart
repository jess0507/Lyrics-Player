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
  purple('Purple', Colors.purple),
  red('Red', Colors.red),
  brown('Brown', Colors.brown),

  /// 單色主題:淺色模式主色為灰、深色模式主色為近白,隨亮度翻轉。
  mono('Grey', Color(0xFF5F6368), isMono: true);

  const AppColorSeed(this.label, this.color, {this.isMono = false});

  final String label;
  final Color color;

  /// 是否為單色(灰 / 白)主題,需特殊建構而非走 [ColorScheme.fromSeed]。
  final bool isMono;

  /// 預設種子色（沿用改版前的藍色）。
  static const AppColorSeed defaultSeed = AppColorSeed.indigo;

  static AppColorSeed fromName(String? name) {
    return values.firstWhere((s) => s.name == name, orElse: () => defaultSeed);
  }
}

/// 集中管理深 / 淺色主題。
class AppTheme {
  AppTheme._();

  static ThemeData light(AppColorSeed seed) => _build(Brightness.light, seed);
  static ThemeData dark(AppColorSeed seed) => _build(Brightness.dark, seed);

  static ThemeData _build(Brightness brightness, AppColorSeed seed) {
    final scheme = seed.isMono
        ? _monoScheme(brightness)
        : ColorScheme.fromSeed(seedColor: seed.color, brightness: brightness);
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }

  /// 灰 / 白單色配色:淺色模式主色為灰、深色模式主色為近白。
  ///
  /// 使用 [DynamicSchemeVariant.monochrome] 產生完全無色相的灰階配色,
  /// 避免一般 `fromSeed` 對 grey 種子仍殘留的藍綠色調(會反映在 NavigationBar
  /// 指示器等 container 色上),再把強調色覆寫為偏好的灰 / 近白。
  static ColorScheme _monoScheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final accent = isLight ? const Color(0xFF5F6368) : const Color(0xFFE8EAED);
    final onAccent = isLight ? Colors.white : Colors.black;
    final base = ColorScheme.fromSeed(
      seedColor: const Color(0xFF5F6368),
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
    );
    return base.copyWith(
      primary: accent,
      onPrimary: onAccent,
      secondary: accent,
      onSecondary: onAccent,
      tertiary: accent,
      onTertiary: onAccent,
      inversePrimary: onAccent,
      primaryContainer: isLight ? accent.withAlpha(120) : accent.withAlpha(120),
    );
  }
}
