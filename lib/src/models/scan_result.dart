import 'file_info.dart';

class ScanResult {
  final String directory;
  final List<FileInfo> files;
  final int emptyDirs;
  final Duration scanTime;

  ScanResult({
    required this.directory,
    required this.files,
    required this.emptyDirs,
    required this.scanTime,
  });

  int get totalFiles => files.length;

  int get totalSize => files.fold(0, (sum, f) => sum + f.size);

  String get totalSizeFormatted {
    int size = totalSize;
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  Map<String, List<FileInfo>> get filesByCategory {
    Map<String, List<FileInfo>> result = {};
    for (var file in files) {
      result.putIfAbsent(file.category, () => []).add(file);
    }
    return result;
  }

  FileInfo? get largestFile {
    if (files.isEmpty) return null;
    return files.reduce((a, b) => a.size > b.size ? a : b);
  }

  FileInfo? get smallestFile {
    if (files.isEmpty) return null;
    return files.reduce((a, b) => a.size < b.size ? a : b);
  }
}