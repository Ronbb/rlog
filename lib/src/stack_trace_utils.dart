const kAsynchronousSuspension = '<asynchronous suspension>';
final kFrameRegex = RegExp(r'#(\d+)\s+(.+)\s+\((.+)\)');

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

  final int index;

  final String caller;

  final String location;

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
