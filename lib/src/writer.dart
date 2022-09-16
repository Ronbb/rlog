import 'dart:async';

export 'writer_stub.dart' if (dart.library.io) 'writer_io.dart';

abstract class Writer {
  const Writer();

  FutureOr<void> write(Object? data);
}

class ConsoleWriter extends Writer {
  const ConsoleWriter();

  @override
  FutureOr<void> write(Object? data) {
    print(data);
  }
}

class MultiWriter extends Writer {
  const MultiWriter(
    this.writers, [
    this.sequential = false,
  ]);

  /// if `false`, [MultiWriter] writes concurrently.
  final bool sequential;

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
