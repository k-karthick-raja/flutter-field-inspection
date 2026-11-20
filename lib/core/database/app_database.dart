import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'migrations.dart';

/// Opens the local SQLite database and applies schema migrations.
///
/// The [DatabaseFactory] is injectable so tests can use an in-memory
/// FFI database instead of the platform plugin.
class AppDatabase {
  AppDatabase({DatabaseFactory? factory, this.path})
      : _factory = factory ?? databaseFactory;

  static const int version = 1;
  static const String fileName = 'field_inspection.db';

  final DatabaseFactory _factory;

  /// Full path to the database file. Defaults to the platform databases dir.
  final String? path;

  Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final dbPath =
        path ?? p.join(await _factory.getDatabasesPath(), fileName);
    return _factory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: version,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, newVersion) => runMigrations(db, 0, newVersion),
        onUpgrade: runMigrations,
      ),
    );
  }

  /// Applies every migration after [from] up to and including [to].
  static Future<void> runMigrations(Database db, int from, int to) async {
    final batch = db.batch();
    for (var v = from + 1; v <= to; v++) {
      final statements = migrations[v];
      if (statements == null) {
        throw StateError('Missing migration for database version $v');
      }
      statements.forEach(batch.execute);
    }
    await batch.commit(noResult: true);
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
