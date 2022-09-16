An easy-to-use logging library with some presets.

## Features

- Create a logger that log messages in your style.
- Preset loggers/encoders/writers.
- Rotation logger.

## Getting started

Add to `pubspec.yaml`.

```yaml
dependencies:
  rlog: <version>
```

## Usage

```dart
/// Console logger
final logger = Logger.console();

logger.debug('some texts');
logger.error('some texts');
```

```dart
/// Rotation logger
final logger = Logger.build(
  encoder: ConsoleEncoder(),
  writer: RotationWriter(
    join(Directory.current.path, 'test-rotation.log'),
    maxCount: 16,
    maxSize: 1 << 12,
  ),
);

for (var i = 0; i < 1000; i++) {
  logger.info('test '.padRight(1 << 6, 'test '));
}
```

```dart
/// MultiWriter logger
final logger = Logger.build(
  encoder: ConsoleEncoder(),
  writer: MultiWriter([
      ConsoleWriter(),
      FileWriter(
      join(Directory.current.path, 'test-multi.log'),
    )
  ]),
);

for (var i = 0; i < 10; i++) {
  await Future.delayed(Duration(milliseconds: 20));
  logger.info('test test');
}
```
