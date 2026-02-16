import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:dart_file_organizer/src/core/file_scanner.dart';

class ScanCommand extends Command<int> {
  ScanCommand() {
    argParser.addFlag(
      'recursive',
      abbr: 'r',
      defaultsTo: true,
      help: 'Scan directories recursively',
    );
  }

  @override
  String get name => 'scan';

  @override
  String get description => 'Scan a directory and display file summary';

  @override
  Future<int> run() async {
    if (argResults!.rest.isEmpty) {
      stderr.writeln('Error: Please provide a directory path.');
      stderr.writeln('Usage: file_organizer scan <directory>');
      return 1;
    }

    String dirPath = argResults!.rest.first;
    bool recursive = argResults!['recursive'] as bool;

    print('📁 Scanning: $dirPath\n');

    try {
      final scanner = FileScanner();
      final result = await scanner.scan(dirPath, recursive: recursive);

      // Print summary
      print('─────────────────────────────────');
      print('📊 Scan Summary');
      print('─────────────────────────────────');
      print('   Directory: ${result.directory}');
      print('   Total files: ${result.totalFiles}');
      print('   Total size: ${result.totalSizeFormatted}');
      print('   Empty dirs: ${result.emptyDirs}');
      print('   Scan time: ${result.scanTime.inMilliseconds}ms');
      print('');

      // Print by category
      print('📂 Files by Category:');
      print('─────────────────────────────────');

      final categories = result.filesByCategory;
      for (var category in categories.keys) {
        final files = categories[category]!;
        final size = files.fold<int>(0, (sum, f) => sum + f.size);
        final sizeStr = _formatSize(size);
        print('   $category: ${files.length} files ($sizeStr)');
      }

      print('');

      // Largest/smallest
      if (result.largestFile != null) {
        print('📈 Largest: ${result.largestFile!.name} (${result.largestFile!.sizeFormatted})');
      }
      if (result.smallestFile != null) {
        print('📉 Smallest: ${result.smallestFile!.name} (${result.smallestFile!.sizeFormatted})');
      }

      return 0;
    } catch (e) {
      stderr.writeln('Error: $e');
      return 1;
    }
  }

  String _formatSize(int size) {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}