import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:rlog/src/writer.dart';

class FileWriter extends Writer {
  FileWriter(this.fileName) {
    file = File.fromUri(fileName);
  }

  final Uri fileName;

  late final File file;

  @override
  FutureOr<void> write(Object? data) {
    file.writeAsStringSync(
      data.toString(),
      mode: FileMode.writeOnlyAppend,
    );
  }
}

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