import 'dart:io';

import 'package:dart_file_organizer/src/cli/runner.dart';

void main(List<String> arguments) async {
  try {
    final exitCode = await FileOrganizerRunner().run(arguments);
    exit(exitCode ?? 0);
  } catch (e) {
    stderr.writeln('Error: $e');
    exit(1);
  }
}
