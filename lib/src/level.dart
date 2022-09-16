enum Level {
  verbose('verbose', 'v'),
  debug('debug', 'd'),
  info('info', 'i'),
  warn('warn', 'w'),
  error('error', 'e'),
  panic('panic', 'p');

  const Level(this.name, this.shortName);

  final String name;

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
