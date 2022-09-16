import 'package:rlog/src/level.dart';

/// Log Message.
class Message {
  const Message({
    required this.dateTime,
    required this.text,
    required this.level,
    required this.stackTrace,
    required this.skip,
  });

  /// When the log created.
  final DateTime dateTime;

  /// Will be encoded by [Encoder].
  final Object? text;

  /// [Level] means severity.
  final Level level;

  /// Where the log created.
  final StackTrace stackTrace;

  /// [stackTrace] maybe is not precise. You can skip some frames to hide logger
  /// internal details.
  final int skip;
}
