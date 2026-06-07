// 以本地 CSV（tool/app_strings.csv）為主，產生 / 更新 lib/l10n/app_<locale>.arb。
//
// 與 gen_l10n_from_sheet.dart 的差異：
//   1. 不下載 Google Sheet，直接讀取本地 CSV（離線、以本地翻譯為主）。
//   2. 採「合併」策略：CSV 內的 key 會覆寫既有 arb 對應值，
//      但 CSV 未列出的 key 會原樣保留，避免精簡 CSV 反而清掉既有翻譯。
//
// 用法：
//   dart run tool/gen_l10n_from_local.dart
//   flutter gen-l10n
//
// 不依賴任何 pub 套件（僅 dart:io / dart:convert），可直接執行。

import 'dart:convert';
import 'dart:io';

void main() {
  final config = _loadConfig('tool/l10n_config.yaml');
  final csvPath = config['local_csv'] ?? 'tool/app_strings.csv';
  final outputDir = config['output_dir'] ?? 'lib/l10n';
  final keyColumn = config['key_column'] ?? 'key';
  final templateLocale = config['template_locale'] ?? 'en';

  final csvFile = File(csvPath);
  if (!csvFile.existsSync()) {
    stderr.writeln('✗ 找不到本地 CSV: $csvPath');
    exit(1);
  }
  stdout.writeln('• 讀取本地 CSV: $csvPath');

  final rows = _parseCsv(csvFile.readAsStringSync());
  if (rows.isEmpty) {
    stderr.writeln('✗ CSV 內容為空');
    exit(1);
  }

  final header = rows.first;
  final keyIndex = header.indexOf(keyColumn);
  if (keyIndex == -1) {
    stderr.writeln('✗ 找不到 key 欄 "$keyColumn"，header = $header');
    exit(1);
  }

  // 語系欄 = header 中除了 key 欄與非語系欄（description）以外的欄。
  // 慣例：key 之後緊接 description，其餘皆為語系欄（欄名即 locale）。
  const nonLocaleColumns = {'key', 'description'};
  final localeColumns = <int, String>{};
  for (var i = 0; i < header.length; i++) {
    final name = header[i].trim();
    if (i == keyIndex || name.isEmpty || nonLocaleColumns.contains(name)) {
      continue;
    }
    localeColumns[i] = name;
  }
  stdout.writeln('• 語系: ${localeColumns.values.join(', ')}');

  final templateIndex = localeColumns.entries
      .firstWhere((e) => e.value == templateLocale,
          orElse: () => localeColumns.entries.first)
      .key;

  // 由 CSV 各語系欄建出 key -> value（空白儲存格 fallback 到 template 欄）。
  final csvMaps = <String, Map<String, String>>{};
  for (final entry in localeColumns.entries) {
    final colIndex = entry.key;
    final locale = entry.value;
    final map = <String, String>{};
    for (final row in rows.skip(1)) {
      if (row.length <= keyIndex) continue;
      final key = row[keyIndex].trim();
      if (key.isEmpty) continue;
      final value = colIndex < row.length ? row[colIndex] : '';
      map[key] = value.trim().isEmpty && templateIndex < row.length
          ? row[templateIndex]
          : value;
    }
    csvMaps[locale] = map;
  }

  // 為帶國碼/字碼的語系（如 zh_CN、zh_TW）補上基底語系（zh）的 CSV 值，
  // 以便基底 arb 也能同步新 key。來源變體可用 base_fallbacks 指定。
  final overrides = _parseFallbacks(config['base_fallbacks']);
  final bases = <String>{
    for (final l in csvMaps.keys)
      if (l.contains('_')) l.split('_').first,
  };
  for (final base in bases) {
    if (csvMaps.containsKey(base)) continue;
    final variants =
        csvMaps.keys.where((l) => l.split('_').first == base).toList();
    final override = overrides[base];
    final source = override != null && csvMaps.containsKey(override)
        ? override
        : variants.first;
    csvMaps[base] = Map<String, String>.from(csvMaps[source]!);
    stdout.writeln('+ 基底 $base ← $source（僅 CSV 內的 key）');
  }

  final dir = Directory(outputDir);
  if (!dir.existsSync()) dir.createSync(recursive: true);

  final encoder = const JsonEncoder.withIndent('  ');
  var fileCount = 0;
  for (final entry in csvMaps.entries) {
    final locale = entry.key;
    final csvValues = entry.value;

    // 合併進既有 arb（保留 CSV 未列出的 key），CSV 值優先。
    final file = File('$outputDir/app_$locale.arb');
    final merged = <String, String>{};
    if (file.existsSync()) {
      final existing =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      for (final e in existing.entries) {
        if (e.key == '@@locale') continue;
        merged[e.key] = e.value as String;
      }
    }
    merged.addAll(csvValues);

    final ordered = <String, String>{'@@locale': locale, ...merged};
    file.writeAsStringSync('${encoder.convert(ordered)}\n');
    fileCount++;
    stdout.writeln('✓ ${file.path} (${merged.length} 字串)');
  }

  stdout.writeln('\n完成，共更新 $fileCount 個 .arb。接著執行: flutter gen-l10n');
}

/// 極簡 YAML 讀取（僅支援 key: "value" / key: value 單層）。
Map<String, String> _loadConfig(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('✗ 找不到設定檔: $path');
    exit(1);
  }
  final result = <String, String>{};
  for (final raw in file.readAsLinesSync()) {
    final line = raw.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final idx = line.indexOf(':');
    if (idx == -1) continue;
    final key = line.substring(0, idx).trim();
    var value = line.substring(idx + 1).trim();
    if (value.startsWith('"') && value.endsWith('"') && value.length >= 2) {
      value = value.substring(1, value.length - 1);
    }
    if (value.isNotEmpty) result[key] = value;
  }
  return result;
}

/// 解析 base_fallbacks 設定，格式："zh=zh_CN,sr=sr_RS" → {zh: zh_CN, sr: sr_RS}。
Map<String, String> _parseFallbacks(String? raw) {
  final result = <String, String>{};
  if (raw == null || raw.trim().isEmpty) return result;
  for (final pair in raw.split(',')) {
    final idx = pair.indexOf('=');
    if (idx == -1) continue;
    final base = pair.substring(0, idx).trim();
    final variant = pair.substring(idx + 1).trim();
    if (base.isNotEmpty && variant.isNotEmpty) result[base] = variant;
  }
  return result;
}

/// RFC 4180 CSV 解析（支援引號、逸出引號、欄內換行）。
List<List<String>> _parseCsv(String text) {
  final rows = <List<String>>[];
  var row = <String>[];
  final field = StringBuffer();
  var inQuotes = false;
  final s = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    if (inQuotes) {
      if (c == '"') {
        if (i + 1 < s.length && s[i + 1] == '"') {
          field.write('"');
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        field.write(c);
      }
    } else {
      if (c == '"') {
        inQuotes = true;
      } else if (c == ',') {
        row.add(field.toString());
        field.clear();
      } else if (c == '\n') {
        row.add(field.toString());
        field.clear();
        rows.add(row);
        row = <String>[];
      } else {
        field.write(c);
      }
    }
  }
  if (field.isNotEmpty || row.isNotEmpty) {
    row.add(field.toString());
    rows.add(row);
  }
  return rows;
}
