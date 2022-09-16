import 'package:rlog/src/level.dart';

class Message {
  const Message({
    required this.dateTime,
    required this.text,
    required this.level,
    required this.stackTrace,
    required this.skip,
  });

  final DateTime dateTime;

  final String text;

  final Level level;

  final StackTrace stackTrace;

  final int skip;
}
