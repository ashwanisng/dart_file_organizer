class FileInfo {
  final String path;
  final String name;
  final String extension;
  final int size; // in bytes
  final DateTime modified;

  FileInfo({
    required this.path,
    required this.name,
    required this.extension,
    required this.size,
    required this.modified,
  });

  String get category {
    switch (extension.toLowerCase()) {
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

  String get sizeFormatted {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}