import 'dart:io';

import 'package:path/path.dart';
import 'package:rlog/src/encoder.dart';
import 'package:rlog/src/logger.dart';
import 'package:rlog/src/writer_io.dart';
import 'package:test/test.dart';

const kTestDirectory = '.test';

void main() {
  final workingDirectory = Directory(
    join(Directory.current.path, kTestDirectory),
  );

  if (!workingDirectory.existsSync()) {
    workingDirectory.createSync(recursive: true);
  }

  Directory.current = Directory(join(Directory.current.path, kTestDirectory));

  group('Console Logger', () {
    late final Logger logger;
    setUp(() {
      logger = Logger.console();
    });

    test('Print Test', () {
      logger.debug('text');
      logger.error('text');
    });
  });

  group('Rotation Logger', () {
    late final Logger logger;
    setUp(() {
      logger = Logger.build(
        encoder: ConsoleEncoder(),
        writer: RotationWriter(
          join(Directory.current.path, 'test.log'),
          maxCount: 16,
          maxSize: 1 << 12,
        ),
      );
    });

    test('Loop Write', () async {
      for (var i = 0; i < 1000; i++) {
        await Future.delayed(Duration(milliseconds: 20));
        logger.info('test '.padRight(1 << 8, 'test '));
      }
    }, timeout: Timeout(Duration(minutes: 5)));
  });
}
