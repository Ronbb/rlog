import 'dart:async';

export 'writer_stub.dart' if (dart.library.io) 'writer_io.dart';

/// Log Writer.
abstract class Writer {
  const Writer();

  /// Write log.
  FutureOr<void> write(Object? data);
}

/// Prints log to stdout or console.
class ConsoleWriter extends Writer {
  const ConsoleWriter();

  @override
  FutureOr<void> write(Object? data) {
    print(data);
  }
}

/// Writes log to other writers.
class MultiWriter extends Writer {
  const MultiWriter(
    this.writers, [
    this.sequential = false,
  ]);

  /// if `false`, [MultiWriter] writes concurrently.
  final bool sequential;

  /// Other writers. Do not make [MultiWriter] recursive.
  final List<Writer> writers;

  @override
  FutureOr<void> write(Object? data) async {
    if (sequential) {
      for (var writer in writers) {
        await writer.write(data);
      }

      return;
    }

    await Future.wait(writers.map((writer) async => writer.write(data)));
  }
}
