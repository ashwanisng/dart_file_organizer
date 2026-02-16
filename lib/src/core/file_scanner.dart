import 'dart:io';

import 'package:path/path.dart' as p;

import '../models/file_info.dart';
import '../models/scan_result.dart';

class FileScanner {
  Future<ScanResult> scan(String dirPath, {bool recursive = true}) async {
    final stopwatch = Stopwatch()..start();

    final dir = Directory(dirPath);
    if (!dir.existsSync()) {
      throw Exception("Directory '$dirPath' does not exist.");
    }

    List<FileInfo> files = [];
    int emptyDirs = 0;

    await _scanDirectory(dir, files, recursive, (isEmpty) {
      if (isEmpty) emptyDirs++;
    });

    stopwatch.stop();

    return ScanResult(
      directory: dir.absolute.path,
      files: files,
      emptyDirs: emptyDirs,
      scanTime: stopwatch.elapsed,
    );
  }

  Future<void> _scanDirectory(
    Directory dir,
    List<FileInfo> files,
    bool recursive,
    Function(bool isEmpty) onDirChecked,
  ) async {
    List<FileSystemEntity> entities;

    try {
      entities = dir.listSync(followLinks: false);
    } catch (e) {
      // Permission denied or other error
      return;
    }

    bool hasFiles = false;

    for (var entity in entities) {
      if (entity is File) {
        hasFiles = true;
        try {
          final stat = entity.statSync();
          files.add(
            FileInfo(
              path: entity.path,
              name: p.basename(entity.path),
              extension: p.extension(entity.path),
              size: stat.size,
              modified: stat.modified,
            ),
          );
        } catch (e) {
          // Skip files we can't read
        }
      } else if (entity is Directory && recursive) {
        // Skip hidden directories
        if (!p.basename(entity.path).startsWith('.')) {
          await _scanDirectory(entity, files, recursive, onDirChecked);
        }
      }
    }

    onDirChecked(!hasFiles && entities.whereType<File>().isEmpty);
  }
}
