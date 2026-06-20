import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'track_cover_entity.dart';
import 'track_cover_provider.dart';
import 'track_cover_repository.dart';

/// 設定封面失敗原因,供 UI 映射到對應的 l10n 失敗訊息。
enum CoverImportError { tooLarge, unreadable }

/// 設定封面失敗;UI 以 [error] 決定 SnackBar 文案。使用者取消選圖不是失敗,
/// 由 [CoverImportService.pickAndSetForTrack] 回 false 表示。
class CoverImportException implements Exception {
  const CoverImportException(this.error);

  final CoverImportError error;
}

/// 自訂封面:挑圖 → 複製到 app 文件夾 `covers/` → upsert(唯一索引 replace)。
/// 「新增」與「更換」共用本路徑,差別只在動作前先刪掉舊圖檔(避免孤兒檔)。
class CoverImportService {
  CoverImportService(this._ref);

  final Ref _ref;

  /// 圖檔大小上限約 10MB,超過拒收。
  static const _maxBytes = 10 * 1024 * 1024;

  /// 為 [trackId] 挑一張封面並設定。回傳 true 表示已設定;false 表示使用者
  /// 取消選圖。失敗(過大 / 無法讀取)拋 [CoverImportException]。
  Future<bool> pickAndSetForTrack(String trackId) async {
    final picked = await FilePicker.pickFiles(type: FileType.image);
    final file = picked?.files.singleOrNull;
    if (file == null || file.path == null) return false; // 取消

    if (file.size > _maxBytes) {
      throw const CoverImportException(CoverImportError.tooLarge);
    }

    final source = File(file.path!);
    final bytes = await _read(source);

    final dir = await _coversDir();
    final ext = _extension(file.name);
    final dest = File(
      '${dir.path}/${DateTime.now().millisecondsSinceEpoch}$ext',
    );
    await dest.writeAsBytes(bytes, flush: true);

    final repo = _ref.read(trackCoverRepositoryProvider);
    await _deleteOldFile(repo.findByTrackId(trackId)?.imagePath);

    final entity = TrackCoverEntity()
      ..trackId = trackId
      ..imagePath = dest.path
      ..addedAt = DateTime.now();
    await repo.save(entity);
    _ref.invalidate(trackCoverProvider(trackId));
    return true;
  }

  /// 移除 [trackId] 的自訂封面(刪圖檔 + 紀錄)。
  Future<void> removeForTrack(String trackId) async {
    final repo = _ref.read(trackCoverRepositoryProvider);
    await _deleteOldFile(repo.findByTrackId(trackId)?.imagePath);
    await repo.deleteByTrackId(trackId);
    _ref.invalidate(trackCoverProvider(trackId));
  }

  Future<List<int>> _read(File source) async {
    try {
      return await source.readAsBytes();
    } on FileSystemException {
      throw const CoverImportException(CoverImportError.unreadable);
    }
  }

  Future<Directory> _coversDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/covers');
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir;
  }

  /// 取副檔名(含 `.`,小寫);無副檔名回 `.img`。
  String _extension(String name) {
    final dot = name.lastIndexOf('.');
    if (dot <= 0 || dot == name.length - 1) return '.img';
    return name.substring(dot).toLowerCase();
  }

  /// 刪除舊封面圖檔;路徑為空或檔案已不在皆靜默略過。
  Future<void> _deleteOldFile(String? path) async {
    if (path == null) return;
    final old = File(path);
    if (old.existsSync()) await old.delete();
  }
}

final coverImportServiceProvider = Provider<CoverImportService>(
  (ref) => CoverImportService(ref),
);
