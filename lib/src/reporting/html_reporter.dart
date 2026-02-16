import 'dart:io';

import 'package:dart_file_organizer/src/models/file_info.dart';
import 'package:dart_file_organizer/src/models/scan_result.dart';

class HtmlReporter {
  void generate(ScanResult result, String outputPath) {
    if (result.files.isEmpty) {
      print('No files found.');
      return;
    }

    StringBuffer rows = StringBuffer();

    for (var entry in result.filesByCategory.entries) {
      String category = entry.key;
      List<FileInfo> files = entry.value;
      int size = files.fold<int>(0, (sum, f) => sum + f.size);

      rows.writeln('<tr>');
      rows.writeln('  <td>$category</td>');
      rows.writeln('  <td>${files.length}</td>');
      rows.writeln('  <td>${_formatSize(size)}</td>');
      rows.writeln('</tr>');
    }

    String tableRows = rows.toString();

    String html =
        '''
<!DOCTYPE html>
<html>
<head>
  <title>File Report</title>
  <style>
    body { font-family: Arial, sans-serif; padding: 20px; }
    table { border-collapse: collapse; width: 100%; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
    th { background-color: #4CAF50; color: white; }
  </style>
</head>
<body>
  <h1>📊 File Report</h1>
  <p><strong>Directory:</strong> ${result.directory}</p>
  <p><strong>Total Files:</strong> ${result.totalFiles}</p>
  <p><strong>Total Size:</strong> ${result.totalSizeFormatted}</p>
  
  <h2>📂 Categories</h2>
  <table>
    <tr>
      <th>Category</th>
      <th>Count</th>
      <th>Size</th>
    </tr>
    $tableRows
  </table>
</body>
</html>
''';

    File(outputPath).writeAsStringSync(html);
    print('✓ Report saved to: $outputPath');
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
