import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_file_organizer/src/core/file_scanner.dart';
import 'package:dart_file_organizer/src/reporting/html_reporter.dart';
import 'package:dart_file_organizer/src/reporting/json_reporter.dart';
import 'package:dart_file_organizer/src/reporting/terminal_reporter.dart';

class ReportCommand extends Command<int> {
  ReportCommand() {
    argParser.addOption(
      'format',
      abbr: 'f',
      defaultsTo: 'terminal',
      allowed: ['terminal', 'json', 'html'],
      help: 'Output format (terminal, json, html)',
    );

    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'Output file path (for json/html)',
    );
    argParser.addFlag(
      'recursive',
      abbr: 'r',
      defaultsTo: false,
      help: 'Scan directories recursively',
    );
  }

  @override
  String get name => 'report';

  @override
  String get description => 'Generate a report of the files';

  @override
  Future<int> run() async {
    if (argResults!.rest.isEmpty) {
      stderr.writeln('Error: Please provide a directory path.');
      stderr.writeln('Usage: file_organizer report <directory>');
      return 1;
    }

    String dirPath = argResults!.rest.first;

    bool recursive = argResults!['recursive'] as bool;
    String format = argResults!['format'] as String;
    String? outputPath = argResults!['output'] as String?;

    print('📁 Scanning: $dirPath\n');

    try {
      final scanner = FileScanner();
      final result = await scanner.scan(dirPath, recursive: recursive);

      // If json/html but no output, create default
      if (format != 'terminal' && outputPath == null) {
        outputPath = 'report.$format';
      }

      switch (format) {
        case 'terminal':
          final terminalReporter = TerminalReporter();
          terminalReporter.generate(result);
        case 'json':
          final jsonReporter = JsonReporter();
          jsonReporter.generate(result, outputPath!);
        case 'html':
          final htmlReporter = HtmlReporter();
          htmlReporter.generate(result, outputPath!);
      }

      return 0;
    } catch (e) {
      stderr.writeln('Error: $e');
      return 1;
    }
  }
}
