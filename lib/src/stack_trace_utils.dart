const kAsynchronousSuspension = '<asynchronous suspension>';
final kFrameRegex = RegExp(r'#(\d+)\s+(.+)\s+\((.+)\)');

/// Parsed from lines in [StackTrace].
class StackTraceFrame {
  const StackTraceFrame({
    required this.caller,
    required this.index,
    required this.location,
    this.isAsynchronousSuspension = false,
  });

  const StackTraceFrame.asynchronousSuspension()
      : index = 0,
        caller = '',
        location = '',
        isAsynchronousSuspension = true;

  /// The number after `#`. Starts from `0`.
  final int index;

  /// Function name.
  final String caller;

  /// <file-parent>/<file>:<row>:<column>
  final String location;

  /// It is not a frame and it displays [kAsynchronousSuspension].
  final bool isAsynchronousSuspension;

  @override
  String toString() {
    if (isAsynchronousSuspension) {
      return kAsynchronousSuspension;
    }

    return '#$index\t$caller ($location)';
  }
}

extension StackTraceUtils on StackTrace {
  /// Parses [StackTrace] to [StackTraceFrame]s.
  Iterable<StackTraceFrame> parse() sync* {
    final all = toString();

    final lines = all.split('\n');

    for (final line in lines) {
      if (line == kAsynchronousSuspension) {
        yield StackTraceFrame.asynchronousSuspension();
        continue;
      }

      final result = kFrameRegex.firstMatch(line);
      if (result == null) {
        continue;
      }

      final index = result.group(1)!;
      final caller = result.group(2)!;
      final location = result.group(3)!;
      yield StackTraceFrame(
        caller: caller,
        index: int.parse(index),
        location: location,
      );
    }
  }
}
