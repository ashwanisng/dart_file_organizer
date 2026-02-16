import 'package:dart_file_organizer/src/models/file_info.dart';

class DuplicateGroup {
  final List<FileInfo> files;
  final String hash;

  DuplicateGroup({required this.files, required this.hash});

  int get wastedBytes {
    if (files.length == 1) return 0;
    return files.skip(1).fold(0, (sum, f) => sum + f.size);
  }
}
