import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:rlog/src/writer.dart';

/// Write log to a file.
///
/// Create the file if not exists.
class FileWriter extends Writer {
  FileWriter(this.path) {
    _file = File(path);
    if (!_file.existsSync()) {
      _file.createSync(recursive: true);
    }
  }

  /// File path.
  final String path;

  late final File _file;

  @override
  FutureOr<void> write(Object? data) {
    _file.writeAsStringSync(
      data.toString(),
      mode: FileMode.writeOnlyAppend,
    );
  }
}

/// Write log to a file with rotations.
class RotationWriter extends Writer {
  RotationWriter(
    this.path, {
    this.maxSize = 1 << 24,
    this.maxCount = 16,
  })  : assert(maxCount > 0),
        assert(maxSize > 0) {
    _file = File(path);
    if (!_file.existsSync()) {
      _file.createSync(recursive: true);
    }
  }

  final int maxSize;

  final int maxCount;

  final String path;

  late File _file;

  String _buildName(int index) {
    return '${withoutExtension(path)}-$index${extension(path)}';
  }

  void _rotate() {
    final file = File(_buildName(maxCount));
    if (file.existsSync()) {
      file.deleteSync();
    }

    for (var i = maxCount - 1; i > 0; i--) {
      final file = File(_buildName(i));
      if (!file.existsSync()) {
        continue;
      }

      file.renameSync(_buildName(i + 1));
    }

    _file.renameSync(_buildName(1));
    _file = File(path);
  }

  @override
  FutureOr<void> write(Object? data) {
    if (_file.statSync().size > maxSize) {
      _rotate();
    }

    _file.writeAsString(
      data.toString(),
      mode: FileMode.writeOnlyAppend,
    );
  }
}
