// 從 Google Sheet 下載翻譯 CSV 並產生 lib/l10n/app_<locale>.arb
//
// 用法：
//   dart run tool/gen_l10n_from_sheet.dart
//   flutter gen-l10n
//
// 不依賴任何 pub 套件（使用 dart:io / dart:convert），可直接執行。

import 'dart:convert';
import 'dart:io';

void main() async {
  final config = _loadConfig('tool/l10n_config.yaml');
  final csvUrl = config['csv_url']!;
  final outputDir = config['output_dir'] ?? 'lib/l10n';
  final keyColumn = config['key_column'] ?? 'key';
  final templateLocale = config['template_locale'] ?? 'en';

  stdout.writeln('↓ 下載 CSV: $csvUrl');
  final csvText = await _download(csvUrl);

  final rows = _parseCsv(csvText);
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

  // 語系欄位 = header 中除了 key 欄以外的欄
  final localeColumns = <int, String>{};
  for (var i = 0; i < header.length; i++) {
    if (i == keyIndex) continue;
    final name = header[i].trim();
    if (name.isNotEmpty) localeColumns[i] = name;
  }
  stdout.writeln('• 語系: ${localeColumns.values.join(', ')}');

  final dir = Directory(outputDir);
  if (!dir.existsSync()) dir.createSync(recursive: true);

  // 先把每個語系欄產生成 map，集中後再寫檔，方便補基底 fallback
  final generated = <String, Map<String, String>>{};
  for (final entry in localeColumns.entries) {
    final colIndex = entry.key;
    final locale = entry.value;

    final map = <String, String>{'@@locale': locale};
    for (final row in rows.skip(1)) {
      if (row.length <= keyIndex) continue;
      final key = row[keyIndex].trim();
      if (key.isEmpty) continue;
      final value = colIndex < row.length ? row[colIndex] : '';
      // 空白儲存格 fallback 到 template 語系欄
      final templateIndex = localeColumns.entries
          .firstWhere((e) => e.value == templateLocale,
              orElse: () => entry)
          .key;
      map[key] = value.trim().isEmpty && templateIndex < row.length
          ? row[templateIndex]
          : value;
    }
    generated[locale] = map;
  }

  // 為帶國碼/字碼的語系（如 zh_CN、zh_TW）自動補上基底語系（zh）當 fallback。
  // gen-l10n 要求：有 xx_YY 時必須存在不帶後綴的 xx.arb。
  // 來源變體可用 base_fallbacks 設定指定（如 "zh=zh_CN"），否則取第一個出現的變體。
  final overrides = _parseFallbacks(config['base_fallbacks']);
  final bases = <String>{
    for (final l in generated.keys)
      if (l.contains('_')) l.split('_').first
  };
  for (final base in bases) {
    if (generated.containsKey(base)) continue; // Sheet 已有明確的基底欄
    final variants =
        generated.keys.where((l) => l.split('_').first == base).toList();
    final override = overrides[base];
    final source = override != null && generated.containsKey(override)
        ? override
        : variants.first;
    generated[base] = Map<String, String>.from(generated[source]!)
      ..['@@locale'] = base;
    stdout.writeln('+ 基底 fallback app_$base.arb ← $source');
  }

  final encoder = const JsonEncoder.withIndent('  ');
  var fileCount = 0;
  for (final locale in generated.keys) {
    final map = generated[locale]!;
    final file = File('$outputDir/app_$locale.arb');
    file.writeAsStringSync('${encoder.convert(map)}\n');
    fileCount++;
    stdout.writeln('✓ ${file.path} (${map.length - 1} 字串)');
  }

  stdout.writeln('\n完成，共產生 $fileCount 個 .arb。接著執行: flutter gen-l10n');
}

/// 極簡 YAML 讀取（僅支援 key: "value" / key: value 單層）
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

/// 解析 base_fallbacks 設定，格式："zh=zh_CN,sr=sr_RS" → {zh: zh_CN, sr: sr_RS}
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

Future<String> _download(String url) async {
  final client = HttpClient();
  try {
    var uri = Uri.parse(url);
    for (var redirect = 0; redirect < 5; redirect++) {
      final req = await client.getUrl(uri);
      req.followRedirects = false;
      final res = await req.close();
      if (res.statusCode == 200) {
        return await res.transform(utf8.decoder).join();
      }
      if (res.statusCode >= 300 && res.statusCode < 400) {
        final loc = res.headers.value(HttpHeaders.locationHeader);
        if (loc == null) break;
        uri = uri.resolve(loc);
        await res.drain();
        continue;
      }
      stderr.writeln('✗ HTTP ${res.statusCode}');
      exit(1);
    }
    stderr.writeln('✗ 重新導向次數過多');
    exit(1);
  } finally {
    client.close();
  }
}

/// RFC 4180 CSV 解析（支援引號、逸出引號、欄內換行）
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
