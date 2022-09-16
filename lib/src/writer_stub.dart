import 'dart:async';
import 'dart:html';
import 'dart:indexed_db';

import 'package:rlog/src/writer.dart';

class IndexDBWriter extends Writer {
  IndexDBWriter(this.name) {
    window.indexedDB!
        .open(name, version: _version, onUpgradeNeeded: _upgrade)
        .then((value) => _db = value);
  }

  final String name;

  Database? _db;

  static const int _version = 1;

  static const String _store = 'Store';

  static void _upgrade(VersionChangeEvent event) {
    final transaction = event.target.transaction;
    final db = transaction?.db;

    if (db == null) {
      return;
    }

    db.createObjectStore(_store);
  }

  @override
  FutureOr<void> write(Object? data) async {
    final db = _db;
    if (db == null) {
      return;
    }
    final store = db.transactionStore(_store, 'readwrite');
    final objectStore = store.objectStore(_store);
    await objectStore.add(data);
  }
}
