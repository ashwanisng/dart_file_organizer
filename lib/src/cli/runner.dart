import 'package:args/command_runner.dart';
import 'package:dart_file_organizer/src/cli/commands/duplicates_command.dart';
import 'package:dart_file_organizer/src/cli/commands/init_command.dart';
import 'package:dart_file_organizer/src/cli/commands/organize_command.dart';
import 'package:dart_file_organizer/src/cli/commands/report_command.dart';
import 'package:dart_file_organizer/src/cli/commands/scan_command.dart';
import 'package:dart_file_organizer/src/cli/commands/watch_command.dart';

class FileOrganizerRunner extends CommandRunner<int> {
  FileOrganizerRunner()
    : super(
        'file_organizer',
        '📁 A CLI tool to scan, analyze, and organize files',
      ) {
    addCommand(ScanCommand());
    addCommand(OrganizeCommand());
    addCommand(DuplicatesCommand());
    addCommand(ReportCommand());
    addCommand(WatchCommand());
    addCommand(InitCommand());
  }
}
