import 'package:dart_file_organizer/src/models/file_info.dart';
import 'package:dart_file_organizer/src/models/scan_result.dart';

class TerminalReporter {
  void generate(ScanResult result) {
    if (result.files.isEmpty) {
      print('No files found.');
      return;
    }

    print('📊 Scan Summary:');
    print('─────────────────────────────────');
    print('   Directory: ${result.directory}');
    print('   Total files: ${result.totalFiles}');
    print('   Total size: ${result.totalSizeFormatted}');
    print('   Empty dirs: ${result.emptyDirs}');
    print('   Scan time: ${result.scanTime.inMilliseconds}ms');
    print('');

    print('📂 Files by Category:');
    print('─────────────────────────────────');
    for (var entry in result.filesByCategory.entries) {
      String category = entry.key;
      List<FileInfo> files = entry.value;
      int size = files.fold<int>(0, (sum, f) => sum + f.size);
      print('   $category: ${files.length} files (${_formatSize(size)})');
    }
    print('');

    if (result.largestFile != null) {
      print(
        '📈 Largest: ${result.largestFile!.name} (${result.largestFile!.sizeFormatted})',
      );
    }
    if (result.smallestFile != null) {
      print(
        '📉 Smallest: ${result.smallestFile!.name} (${result.smallestFile!.sizeFormatted})',
      );
    }
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
