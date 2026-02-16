# 📁 Dart File Organizer

A powerful CLI tool to scan, analyze, and organize files by type, find duplicates, and generate reports.

Built with Dart as a practice project for learning CLI development.

---

## ✨ Features

| Command | Description |
|---------|-------------|
| `scan` | Analyze directory contents and show summary |
| `organize` | Move files into folders by type (Images, Documents, etc.) |
| `duplicates` | Find duplicate files using MD5 hashing |
| `report` | Generate reports in terminal, JSON, or HTML format |
| `watch` | Watch directory and auto-organize new files in real-time |
| `init` | Create a configuration file |

---

## 🚀 Installation

### Prerequisites

- Dart SDK >= 3.0.0

### Clone and Install

```bash
git clone https://github.com/yourusername/dart_file_organizer.git
cd dart_file_organizer
dart pub get
```

---

## 📖 Usage

### Scan Command

Analyze a directory and display file statistics.

```bash
# Scan current directory
dart run bin/dart_file_organizer.dart scan .

# Scan specific directory
dart run bin/dart_file_organizer.dart scan ~/Downloads

# Scan without recursion
dart run bin/dart_file_organizer.dart scan ~/Downloads --no-recursive
```

**Output:**
```
📁 Scanning: /Users/username/Downloads

─────────────────────────────────
📊 Scan Summary
─────────────────────────────────
   Directory: /Users/username/Downloads
   Total files: 150
   Total size: 2.57 GB
   Empty dirs: 12
   Scan time: 45ms

📂 Files by Category:
─────────────────────────────────
   Images: 45 files (156.2 MB)
   Documents: 32 files (24.5 MB)
   Videos: 8 files (1.8 GB)
   Audio: 15 files (89.3 MB)
   Code: 28 files (2.1 MB)
   Archives: 12 files (450.0 MB)
   Other: 10 files (15.6 MB)

📈 Largest: movie.mp4 (1.2 GB)
📉 Smallest: readme.txt (0 B)
```

---

### Organize Command

Move files into category folders automatically.

```bash
# Preview changes (dry run)
dart run bin/dart_file_organizer.dart organize ~/Downloads --dry-run

# Actually organize files
dart run bin/dart_file_organizer.dart organize ~/Downloads

# Organize with subdirectories
dart run bin/dart_file_organizer.dart organize ~/Downloads --recursive
```

**Options:**
| Flag | Short | Description |
|------|-------|-------------|
| `--dry-run` | `-d` | Preview changes without moving files |
| `--recursive` | `-r` | Include files in subdirectories |

**Before:**
```
Downloads/
├── photo.jpg
├── resume.pdf
├── song.mp3
└── script.dart
```

**After:**
```
Downloads/
├── Images/
│   └── photo.jpg
├── Documents/
│   └── resume.pdf
├── Audio/
│   └── song.mp3
└── Code/
    └── script.dart
```

---

### Duplicates Command

Find duplicate files by comparing content hashes.

```bash
# Find duplicates
dart run bin/dart_file_organizer.dart duplicates ~/Downloads

# Find duplicates (non-recursive)
dart run bin/dart_file_organizer.dart duplicates ~/Downloads --no-recursive
```

**Output:**
```
🔍 Scanning for duplicates in: /Users/username/Downloads

   Found 150 files, calculating hashes...

Found 3 duplicate groups:

📄 photo.jpg (3 copies) - 4.5 MB wasted
   → /Downloads/photo.jpg
   → /Downloads/backup/photo.jpg
   → /Downloads/old/photo.jpg

📄 document.pdf (2 copies) - 1.2 MB wasted
   → /Downloads/document.pdf
   → /Downloads/archive/document.pdf

─────────────────────────────────
📊 Total: 3 duplicate files
   Wasted space: 5.7 MB
```

---

### Report Command

Generate reports in different formats.

```bash
# Terminal report (default)
dart run bin/dart_file_organizer.dart report ~/Downloads

# JSON report
dart run bin/dart_file_organizer.dart report ~/Downloads --format json

# HTML report
dart run bin/dart_file_organizer.dart report ~/Downloads --format html

# Specify output file
dart run bin/dart_file_organizer.dart report ~/Downloads --format json --output my-report.json
```

**Options:**
| Flag | Short | Description |
|------|-------|-------------|
| `--format` | `-f` | Output format: `terminal`, `json`, `html` |
| `--output` | `-o` | Output file path |
| `--recursive` | `-r` | Scan directories recursively |

---

### Watch Command

Monitor a directory and auto-organize new files.

```bash
# Watch current directory
dart run bin/dart_file_organizer.dart watch

# Watch specific directory
dart run bin/dart_file_organizer.dart watch -d ~/Downloads

# Watch with subdirectories
dart run bin/dart_file_organizer.dart watch -d ~/Downloads --recursive
```

**Output:**
```
👁️ Watching: /Users/username/Downloads
   Press Ctrl+C to stop

   ✓ photo.jpg → Images/
   ✓ document.pdf → Documents/
   ✓ song.mp3 → Audio/
```

---

### Init Command

Create a configuration file.

```bash
# Create config file
dart run bin/dart_file_organizer.dart init

# Overwrite existing config
dart run bin/dart_file_organizer.dart init --force
```

**Generated `file_organizer_config.yaml`:**
```yaml
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
```

---

## 📂 Project Structure

```
dart_file_organizer/
├── bin/
│   └── dart_file_organizer.dart       # Entry point
├── lib/
│   └── src/
│       ├── cli/
│       │   ├── runner.dart            # CommandRunner
│       │   └── commands/
│       │       ├── scan_command.dart
│       │       ├── organize_command.dart
│       │       ├── duplicates_command.dart
│       │       ├── report_command.dart
│       │       ├── watch_command.dart
│       │       └── init_command.dart
│       ├── core/
│       │   ├── file_scanner.dart      # Directory scanning logic
│       │   └── duplicate_finder.dart  # MD5 hash comparison
│       ├── models/
│       │   ├── file_info.dart         # File metadata model
│       │   ├── scan_result.dart       # Scan results model
│       │   └── duplicate_group.dart   # Duplicate group model
│       ├── reporting/
│       │   ├── terminal_reporter.dart
│       │   ├── json_reporter.dart
│       │   └── html_reporter.dart
│       └── config/
│           └── config_loader.dart
├── test/
├── pubspec.yaml
└── README.md
```

---

## 📦 Dependencies

```yaml
dependencies:
  args: ^2.4.2
  path: ^1.8.3
  crypto: ^3.0.3
  yaml: ^3.1.2
  mason_logger: ^0.3.0

dev_dependencies:
  test: ^1.24.0
```

---

## 🎯 File Categories

| Category | Extensions |
|----------|------------|
| Images | `.jpg`, `.jpeg`, `.png`, `.gif`, `.webp`, `.svg` |
| Documents | `.pdf`, `.doc`, `.docx`, `.txt`, `.md` |
| Videos | `.mp4`, `.avi`, `.mov`, `.mkv` |
| Audio | `.mp3`, `.wav`, `.flac`, `.aac` |
| Code | `.dart`, `.js`, `.py`, `.java`, `.ts`, `.html`, `.css` |
| Archives | `.zip`, `.rar`, `.tar`, `.gz` |
| Other | Everything else (not moved during organize) |

---

## 🛠️ Development

### Run from source

```bash
dart run bin/dart_file_organizer.dart <command> [options]
```

### Compile to executable

```bash
dart compile exe bin/dart_file_organizer.dart -o file_organizer
./file_organizer scan ~/Downloads
```

### Run tests

```bash
dart test
```

---

## 📝 License

MIT License - feel free to use this project for learning and personal use.

---
