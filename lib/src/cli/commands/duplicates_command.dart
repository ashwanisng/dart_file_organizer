import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_file_organizer/src/core/duplicate_finder.dart';
import 'package:dart_file_organizer/src/core/file_scanner.dart';

class DuplicatesCommand extends Command<int> {
  DuplicatesCommand() {
    argParser.addFlag(
      'recursive',
      abbr: 'r',
      defaultsTo: true,
      help: 'Scan directories recursively',
    );
  }

  @override
  String get name => 'duplicates';

  @override
  String get description => 'Find duplicate files by comparing content';

  @override
  Future<int> run() async {
    if (argResults!.rest.isEmpty) {
      stderr.writeln('Error: Please provide a directory path.');
      stderr.writeln('Usage: file_organizer duplicates <directory>');
      return 1;
    }

    String dirPath = argResults!.rest.first;
    bool recursive = argResults!['recursive'] as bool;

    print('🔍 Scanning for duplicates in: $dirPath\n');

    try {
      final scanner = FileScanner();
      final result = await scanner.scan(dirPath, recursive: recursive);

      if (result.files.isEmpty) {
        print('No files found.');
        return 0;
      }

      print('   Found ${result.files.length} files, calculating hashes...\n');

      final finder = DuplicateFinder();
      final duplicates = await finder.findDuplicates(result.files);

      if (duplicates.isEmpty) {
        print('✨ No duplicate files found!');
        return 0;
      }

      print('Found ${duplicates.length} duplicate groups:\n');

      int totalDuplicates = 0;
      int totalWasted = 0;

      for (var group in duplicates) {
        final firstFile = group.files.first;
        print(
          '📄 ${firstFile.name} (${group.files.length} copies) - ${_formatSize(group.wastedBytes)} wasted',
        );

        for (var file in group.files) {
          print('   → ${file.path}');
        }
        print('');

        totalDuplicates += group.files.length - 1;
        totalWasted += group.wastedBytes;
      }

      print('─────────────────────────────────');
      print('📊 Total: $totalDuplicates duplicate files');
      print('   Wasted space: ${_formatSize(totalWasted)}');

      return 0;
    } catch (e) {
      stderr.writeln('Error: $e');
      return 1;
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
