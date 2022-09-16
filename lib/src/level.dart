/// [Level] means severity. You can filter logs by level.
enum Level {
  /// Everythings.
  verbose('verbose', 'v'),

  /// Maybe the log should be hidden in production release.
  debug('debug', 'd'),

  /// Just tell you something.
  info('info', 'i'),

  /// Something not good.
  warn('warn', 'w'),

  /// Work badly, but not crash.
  error('error', 'e'),

  /// Crash then.
  panic('panic', 'p');

  const Level(this.name, this.shortName);

  /// Full name.
  final String name;

  /// short name.
  final String shortName;

  bool operator >(Level other) {
    return index > other.index;
  }

  bool operator >=(Level other) {
    return index >= other.index;
  }

  bool operator <(Level other) {
    return index < other.index;
  }

  bool operator <=(Level other) {
    return index <= other.index;
  }
}
