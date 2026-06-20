import 'dart:io';

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

/// 從封面圖檔以 [PaletteGenerator] 抽出主色;圖檔遺失 / 無法解碼等任何
/// 失敗皆回 null(best-effort,呼叫端據此退回主題色)。
Future<Color?> extractCoverColor(File file) async {
  try {
    final palette = await PaletteGenerator.fromImageProvider(
      FileImage(file),
      maximumColorCount: 16,
    );
    return palette.dominantColor?.color;
  } catch (_) {
    return null;
  }
}
