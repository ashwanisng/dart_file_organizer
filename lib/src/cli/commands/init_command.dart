import 'dart:io';

import 'package:args/command_runner.dart';

class InitCommand extends Command<int> {
  InitCommand() {
    argParser.addFlag(
      'force',
      abbr: 'f',
      defaultsTo: false,
      help: 'Overwrite existing config file',
    );
  }

  @override
  String get name => 'init';

  @override
  String get description => 'Create a configuration file';

  @override
  Future<int> run() async {
    if (argResults!.rest.isNotEmpty) {
      stderr.writeln(
        'Error: Unexpected arguments: ${argResults!.rest.join(' ')}',
      );
      stderr.writeln('Usage: file_organizer init');
      return 1;
    }

    final configFile = File('file_organizer_config.yaml');

    bool force = argResults!['force'] as bool;

    if (configFile.existsSync() && !force) {
      stderr.writeln('Error: Configuration file already exists.');
      stderr.writeln('Use --force to overwrite.');
      return 1;
    }

    await configFile.writeAsString('''
# File Organizer Configuration
    
categories:
  Images:
    - .jpg
    - .jpeg
    - .png
    - .gif
    - .webp
    - .svg
  Documents:
    - .pdf
    - .doc
    - .docx
    - .txt
    - .md
  Videos:
    - .mp4
    - .avi
    - .mov
    - .mkv
  Audio:
    - .mp3
    - .wav
    - .flac
    - .aac
  Code:
    - .dart
    - .js
    - .py
    - .java
    - .ts
    - .html
    - .css
  Archives:
    - .zip
    - .rar
    - .tar
    - .gz

options:
  recursive: true
  skipHidden: true
  skipOther: true
    ''');

    print('✓ Created: file_organizer_config.yaml');
    print('');
    print('You can now customize your organization rules!');
    return 0;
  }
}
