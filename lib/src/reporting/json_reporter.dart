import 'dart:convert';
import 'dart:io';

import 'package:dart_file_organizer/src/models/file_info.dart';
import 'package:dart_file_organizer/src/models/scan_result.dart';

class JsonReporter {
  void generate(ScanResult result, String outputPath) {
    if (result.files.isEmpty) {
      print('No files found.');
      return;
    }

    Map<String, dynamic> fileCategories = {};

    for (var entry in result.filesByCategory.entries) {
      String category = entry.key;
      List<FileInfo> files = entry.value;
      int size = files.fold<int>(0, (sum, f) => sum + f.size);
      fileCategories[category] = {
        'count': files.length,
        'size': _formatSize(size),
      };
    }

    Map<String, dynamic> reportData = {
      'directory': result.directory,
      'totalFiles': result.totalFiles,
      'totalSize': result.totalSizeFormatted,
      'emptyDirs': result.emptyDirs,
      'categories': fileCategories,
      'scanTime': result.scanTime.inMilliseconds,
      'largestFile': result.largestFile != null
          ? {
              'name': result.largestFile!.name,
              'size': result.largestFile!.sizeFormatted,
            }
          : null,
      'smallestFile': result.smallestFile != null
          ? {
              'name': result.smallestFile!.name,
              'size': result.smallestFile!.sizeFormatted,
            }
          : null,
      'generatedAt': DateTime.now().toIso8601String(),
    };

    String reportJson = JsonEncoder.withIndent('  ').convert(reportData);
    File(outputPath).writeAsStringSync(reportJson);
    print('✓ Report saved to: $outputPath');
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
