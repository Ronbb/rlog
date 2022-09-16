import 'package:rlog/src/encoder.dart';
import 'package:rlog/src/level.dart';
import 'package:rlog/src/message.dart';
import 'package:rlog/src/writer.dart';

const _kDefaultSkip = 2;

/// Log Controller.
///
/// See also:
/// [Encoder] encodes [Message] log object, usually a [String].
/// [Writer] writes log object to filesystem or others.
class Logger {
  /// Preset.
  ///
  /// Prints logs to stdout or console.
  const Logger.console()
      : _encoder = const ConsoleEncoder(),
        _writer = const ConsoleWriter();

  /// Build a custom logger.
  const Logger.build({
    required Encoder encoder,
    required Writer writer,
  })  : _encoder = encoder,
        _writer = writer;

  final Encoder _encoder;

  final Writer _writer;

  /// Log with level [Level.verbose].
  void verbose(Object? text, [StackTrace? stackTrace]) {
    _write(Level.verbose, text, stackTrace);
  }

  /// Log with level [Level.debug].
  void debug(Object? text, [StackTrace? stackTrace]) {
    _write(Level.debug, text, stackTrace);
  }

  /// Log with level [Level.info].
  void info(Object? text, [StackTrace? stackTrace]) {
    _write(Level.info, text, stackTrace);
  }

  /// Log with level [Level.error].
  void error(Object? text, [StackTrace? stackTrace]) {
    _write(Level.error, text, stackTrace);
  }

  /// Log with level [Level.panic].
  void panic(Object? text, [StackTrace? stackTrace]) {
    _write(Level.panic, text, stackTrace);
  }

  /// Write a general log.
  void _write(Level level, Object? text, [StackTrace? stackTrace]) {
    write(
      Message(
        dateTime: DateTime.now(),
        text: text,
        level: level,
        stackTrace: stackTrace ?? StackTrace.current,
        skip: stackTrace == null ? _kDefaultSkip : 0,
      ),
    );
  }

  void write(Message message) {
    _writer.write(_encoder.encode(message));
  }
}
