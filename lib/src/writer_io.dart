import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';

import 'writer.dart';

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
class InternalRotationWriter extends RotationWriter {
  InternalRotationWriter(
    this.options,
  ) {
    _file = File(options.path);
    if (!_file.existsSync()) {
      _file.createSync(recursive: true);
    }
  }

  final RotationWriterOptions options;

  late File _file;

  String _buildName(int index) {
    return '${withoutExtension(options.path)}-$index${extension(options.path)}';
  }

  void _rotate() {
    final file = File(_buildName(options.maxCount));
    if (file.existsSync()) {
      file.deleteSync();
    }

    for (var i = options.maxCount - 1; i > 0; i--) {
      final file = File(_buildName(i));
      if (!file.existsSync()) {
        continue;
      }

      file.renameSync(_buildName(i + 1));
    }

    _file.renameSync(_buildName(1));
    _file = File(options.path);
  }

  @override
  FutureOr<void> write(Object? data) {
    if (_file.statSync().size > options.maxSize) {
      _rotate();
    }

    _file.writeAsString(
      data.toString(),
      mode: FileMode.writeOnlyAppend,
    );
  }
}
