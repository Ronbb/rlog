import 'package:rlog/src/encoder.dart';
import 'package:rlog/src/level.dart';
import 'package:rlog/src/message.dart';
import 'package:rlog/src/writer.dart';

const _kDefaultSkip = 2;

class Logger {
  const Logger.console()
      : _encoder = const ConsoleEncoder(),
        _writer = const ConsoleWriter();

  const Logger.build({
    required Encoder encoder,
    required Writer writer,
  })  : _encoder = encoder,
        _writer = writer;

  final Encoder _encoder;

  final Writer _writer;

  void verbose(Object? text, [StackTrace? stackTrace]) {
    _write(Level.verbose, text, stackTrace);
  }

  void debug(Object? text, [StackTrace? stackTrace]) {
    _write(Level.debug, text, stackTrace);
  }

  void info(Object? text, [StackTrace? stackTrace]) {
    _write(Level.info, text, stackTrace);
  }

  void error(Object? text, [StackTrace? stackTrace]) {
    _write(Level.error, text, stackTrace);
  }

  void panic(Object? text, [StackTrace? stackTrace]) {
    _write(Level.panic, text, stackTrace);
  }

  void _write(Level level, Object? text, [StackTrace? stackTrace]) {
    write(
      Message(
        dateTime: DateTime.now(),
        text: text.toString(),
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
