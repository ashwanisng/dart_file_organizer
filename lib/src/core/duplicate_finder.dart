import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dart_file_organizer/src/models/duplicate_group.dart';
import 'package:dart_file_organizer/src/models/file_info.dart';

class DuplicateFinder {
  Future<List<DuplicateGroup>> findDuplicates(List<FileInfo> files) async {
    Map<int, List<FileInfo>> bySize = {};
    Map<String, List<FileInfo>> byHash = {};

    // Step 1: Group files by size (fast filter)
    for (var file in files) {
      if (file.size == 0) continue; // Skip empty files
      bySize.putIfAbsent(file.size, () => []).add(file);
    }

    // Step 2: Hash only files with matching sizes
    for (var sizeGroup in bySize.values) {
      if (sizeGroup.length < 2) continue;

      for (var file in sizeGroup) {
        try {
          final bytes = File(file.path).readAsBytesSync();
          final hash = md5.convert(bytes).toString();
          byHash.putIfAbsent(hash, () => []).add(file);
        } catch (e) {
          // Skip files we can't read (permission errors, etc.)
        }
      }
    }

    // Step 3: Build duplicate groups
    List<DuplicateGroup> groups = [];
    for (var entry in byHash.entries) {
      if (entry.value.length < 2) continue;
      groups.add(DuplicateGroup(files: entry.value, hash: entry.key));
    }

    // Sort by wasted space (largest first)
    groups.sort((a, b) => b.wastedBytes.compareTo(a.wastedBytes));

    return groups;
  }
}
