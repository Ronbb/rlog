import 'package:rlog/src/level.dart';
import 'package:rlog/src/message.dart';
import 'package:rlog/src/stack_trace_encoder.dart';

abstract class Encoder<M extends Message> {
  const Encoder();

  String encode(covariant M message);
}

class ConsoleEncoder extends Encoder<Message> {
  const ConsoleEncoder({
    this.stackTraceEncoder = const CustomStackTraceEncoder(),
  });

  final StackTraceEncoder stackTraceEncoder;

  @override
  String encode(Message message) {
    final buffer = StringBuffer();
    final dateTime = _formatDateTime(message.dateTime);
    final level = message.level;
    final levelText = level.name.toUpperCase();
    final text = message.text;
    final stackTrace = stackTraceEncoder.customize(
      message.stackTrace,
      message.skip,
    );
    buffer.writeAll([
      '[$dateTime]',
      levelText,
      stackTrace.firstCaller,
      stackTrace.firstShortLocation,
      text,
    ], '\t');
    buffer.write('\n');

    if (level > Level.info) {
      buffer.writeln(stackTraceEncoder.encode(stackTrace));
    }

    return buffer.toString();
  }

  static String _formatDateTime(DateTime dateTime) {
    String y = _paddingNumber(dateTime.year, 4);
    String m = _paddingNumber(dateTime.month, 2);
    String d = _paddingNumber(dateTime.day, 2);
    String h = _paddingNumber(dateTime.hour, 2);
    String min = _paddingNumber(dateTime.minute, 2);
    String sec = _paddingNumber(dateTime.second, 2);
    String ms = _paddingNumber(dateTime.millisecond, 3);
    if (dateTime.isUtc) {
      return "$y-$m-$d $h:$min:$sec.${ms}Z";
    } else {
      return "$y-$m-$d $h:$min:$sec.$ms";
    }
  }

  static String _paddingNumber(int n, int length) {
    final padded = n.abs().toString().padLeft(length, '0');
    if (n.isNegative) {
      return '-$padded';
    }
    return padded;
  }
}
