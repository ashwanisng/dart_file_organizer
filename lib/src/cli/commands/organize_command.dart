import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_file_organizer/src/core/file_scanner.dart';
import 'package:path/path.dart' as p;

class OrganizeCommand extends Command<int> {
  OrganizeCommand() {
    argParser.addFlag(
      'dry-run',
      abbr: 'd',
      defaultsTo: false,
      help: 'Preview changes without moving files',
    );

    argParser.addFlag(
      'recursive',
      abbr: 'r',
      defaultsTo: false,
      help:
          'Scan subdirectories (organize only moves top-level files by default)',
    );
  }

  @override
  String get name => 'organize';

  @override
  String get description =>
      'Move files into folders by type (Images, Documents, etc.)';

  @override
  Future<int> run() async {
    if (argResults!.rest.isEmpty) {
      stderr.writeln('Error: Please provide a directory path.');
      stderr.writeln('Usage: file_organizer organize <directory> [--dry-run]');
      return 1;
    }

    String dirPath = argResults!.rest.first;
    bool dryRun = argResults!['dry-run'] as bool;
    bool recursive = argResults!['recursive'] as bool;

    if (dryRun) {
      print('🔍 DRY RUN - No files will be moved\n');
    }

    print('📁 Organizing: $dirPath\n');

    try {
      final scanner = FileScanner();
      final result = await scanner.scan(dirPath, recursive: recursive);

      if (result.files.isEmpty) {
        print('No files found to organize.');
        return 0;
      }

      final categories = result.filesByCategory;
      int movedCount = 0;
      int skippedCount = 0;

      for (var category in categories.keys) {
        if (category == 'Other') {
          skippedCount += categories[category]!.length;
          continue;
        }

        final files = categories[category]!;
        final categoryDir = Directory(p.join(dirPath, category));

        if (!dryRun && !categoryDir.existsSync()) {
          categoryDir.createSync();
          print('📂 Created: $category/');
        }

        for (var fileInfo in files) {
          final sourceFile = File(fileInfo.path);
          final destPath = p.join(categoryDir.path, fileInfo.name);
          final destFile = File(destPath);

          // Skip if already in correct folder
          if (p.dirname(fileInfo.path) == categoryDir.path) {
            continue;
          }

          // Handle duplicate filenames
          String finalDestPath = destPath;
          if (destFile.existsSync()) {
            finalDestPath = _getUniquePath(destPath);
          }

          // Move or preview
          if (dryRun) {
            print('   📄 ${fileInfo.name} → $category/');
          } else {
            try {
              sourceFile.renameSync(finalDestPath);
              print('   ✓ ${fileInfo.name} → $category/');
              movedCount++;
            } catch (e) {
              stderr.writeln('   ✗ Failed to move ${fileInfo.name}: $e');
            }
          }
        }
      }

      print('');
      print('─────────────────────────────────');
      if (dryRun) {
        int toMove = result.totalFiles - skippedCount;
        print(
          '📊 Would organize $toMove files into ${categories.length - 1} folders',
        );
        print('   (Run without --dry-run to apply changes)');
      } else {
        print('📊 Organized $movedCount files');
        print('   Skipped: $skippedCount files (Other category)');
      }
      return 0;
    } catch (e) {
      stderr.writeln('Error: $e');
      return 1;
    }
  }

  String _getUniquePath(String path) {
    final dir = p.dirname(path);
    final name = p.basenameWithoutExtension(path);
    final ext = p.extension(path);

    int counter = 1;
    String newPath = path;

    while (File(newPath).existsSync()) {
      newPath = p.join(dir, '$name ($counter)$ext');
      counter++;
    }

    return newPath;
  }
}
