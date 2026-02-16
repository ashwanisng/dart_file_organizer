import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

class WatchCommand extends Command<int> {
  WatchCommand() {
    argParser.addOption(
      'directory',
      abbr: 'd',
      help: 'Directory to watch for changes',
      defaultsTo: '.',
    );

    argParser.addFlag(
      'recursive',
      abbr: 'r',
      defaultsTo: true,
      help: 'Watch directories recursively',
    );
  }

  @override
  String get name => 'watch';

  @override
  String get description =>
      'Watch a directory for changes and update report in real-time';

  @override
  Future<int> run() async {
    if (argResults!.rest.isNotEmpty) {
      stderr.writeln(
        'Error: Unexpected arguments: ${argResults!.rest.join(' ')}',
      );
      stderr.writeln('Usage: file_organizer watch -d <directory>');
      return 1;
    }

    String dirPath = argResults!['directory'] as String;
    bool recursive = argResults!['recursive'] as bool;
    final dir = Directory(dirPath);

    if (!dir.existsSync()) {
      stderr.writeln('Error: Directory "$dirPath" does not exist.');
      return 1;
    }

    print('👁️ Watching: ${dir.absolute.path}');
    print('   Press Ctrl+C to stop\n');

    Stream<FileSystemEvent> events = dir.watch(recursive: recursive);

    await for (var event in events) {
      if (event is FileSystemCreateEvent) {
        if (FileSystemEntity.isDirectorySync(event.path)) continue;

        if (event.path.contains('/.')) continue;

        _organizeFile(event.path, dirPath);
      }
    }
    return 0;
  }

  void _organizeFile(String filePath, String baseDir) {

    if (!File(filePath).existsSync()) return;

    String ext = p.extension(filePath).toLowerCase();
    String category = _getCategory(ext);

    // 3. Skip "Other"
    if (category == 'Other') return;

    // 4. Create category folder
    Directory categoryDir = Directory(p.join(baseDir, category));
    if (!categoryDir.existsSync()) {
      categoryDir.createSync();
    }

    String fileName = p.basename(filePath);
    String destPath = p.join(categoryDir.path, fileName);
    try {
      File(filePath).renameSync(destPath);
      print('   ✓ $fileName → $category/');
    } catch (e) {
      stderr.writeln('   ✗ Failed to move $fileName: $e');
    }
  }

  String _getCategory(String ext) {
    switch (ext.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
      case '.webp':
      case '.svg':
        return 'Images';
      case '.pdf':
      case '.doc':
      case '.docx':
      case '.txt':
      case '.md':
        return 'Documents';
      case '.mp4':
      case '.avi':
      case '.mov':
      case '.mkv':
        return 'Videos';
      case '.mp3':
      case '.wav':
      case '.flac':
      case '.aac':
        return 'Audio';
      case '.dart':
      case '.js':
      case '.py':
      case '.java':
      case '.ts':
      case '.html':
      case '.css':
        return 'Code';
      case '.zip':
      case '.rar':
      case '.tar':
      case '.gz':
        return 'Archives';
      default:
        return 'Other';
    }
  }
}
