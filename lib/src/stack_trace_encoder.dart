import 'dart:math';

import 'package:rlog/src/stack_trace_utils.dart';

/// [StackTraceEncoder] encodes [StackTrace]
abstract class StackTraceEncoder {
  const StackTraceEncoder();

  /// Parse [StackTrace] and convert to [CustomStackTrace].
  CustomStackTrace customize(StackTrace stackTrace, [int skip = 0]);

  /// Convert [StackTrace] to text.
  String encode(StackTrace stackTrace, [int skip = 0]);
}

/// Common [StackTrace]. It provides a console-style formatter.
class CustomStackTrace extends StackTrace {
  CustomStackTrace(StackTrace stackTrace, this.skip) {
    allFrames = stackTrace.parse().toList();

    var frames = <StackTraceFrame>[];
    var skipped = 0;

    for (final frame in allFrames) {
      if (frame.isAsynchronousSuspension) {
        if (frames.isEmpty || !frames.last.isAsynchronousSuspension) {
          frames.add(frame);
        }
        continue;
      }

      if (skipped < skip) {
        skipped++;
        continue;
      }

      frames.add(frame);
    }

    this.skipped = skipped;
    this.frames = frames;
  }

  /// includes skipped frames.
  late final List<StackTraceFrame> allFrames;

  /// does not include skipped frames.
  late final List<StackTraceFrame> frames;

  final int skip;

  late final int skipped;

  String get firstCaller {
    if (frames.isEmpty) {
      return '';
    }

    return frames.first.caller;
  }

  String get firstShortLocation {
    if (frames.isEmpty) {
      return '';
    }

    final location = frames.first.location;

    var spiltted = location.split('/').toList();
    if (spiltted.isEmpty) {
      return '';
    }

    spiltted = spiltted.sublist(
      max(0, spiltted.length - 2),
      spiltted.length,
    );

    return spiltted.join('/');
  }

  @override
  String toString() {
    final buffer = StringBuffer();

    if (skipped > 0) {
      buffer.writeln('<skip $skipped frame(s)>');
    }

    buffer.writeAll(frames, '\n');

    return buffer.toString();
  }
}

class CustomStackTraceEncoder extends StackTraceEncoder {
  const CustomStackTraceEncoder();

  @override
  CustomStackTrace customize(StackTrace stackTrace, [int skip = 0]) {
    assert(skip >= 0);

    if (stackTrace is CustomStackTrace) {
      return stackTrace;
    }
    return CustomStackTrace(stackTrace, skip);
  }

  @override
  String encode(StackTrace stackTrace, [int skip = 0]) {
    assert(skip >= 0);

    return customize(stackTrace, skip).toString();
  }
}
