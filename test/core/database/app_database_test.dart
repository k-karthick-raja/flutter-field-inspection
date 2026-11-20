import 'package:field_inspection/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late AppDatabase appDatabase;

  setUpAll(sqfliteFfiInit);

  setUp(() {
    appDatabase = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
  });

  tearDown(() => appDatabase.close());

  Future<List<String>> tableNames(Database db) async {
    final rows = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table' "
      "AND name NOT LIKE 'sqlite_%' AND name != 'android_metadata'",
    );
    return rows.map((r) => r['name'] as String).toList();
  }

  test('creates the schema at the current version', () async {
    final db = await appDatabase.database;

    expect(await db.getVersion(), AppDatabase.version);
    expect(
      await tableNames(db),
      containsAll(['sites', 'inspections', 'checklist_items']),
    );
  });

  test('deleting an inspection cascades to its checklist items', () async {
    final db = await appDatabase.database;
    await db.insert('sites', {'id': 's1', 'name': 'Depot', 'address': 'A'});
    await db.insert('inspections', {
      'id': 'i1',
      'site_id': 's1',
      'title': 'Fire safety',
      'status': 'scheduled',
      'scheduled_for': '2026-11-25T09:00:00Z',
      'updated_at': '2026-11-20T09:00:00Z',
    });
    await db.insert('checklist_items', {
      'id': 'c1',
      'inspection_id': 'i1',
      'label': 'Exit signs lit',
    });

    await db.delete('inspections', where: 'id = ?', whereArgs: ['i1']);

    expect(await db.query('checklist_items'), isEmpty);
  });

  test('runMigrations fails loudly when a version is missing', () async {
    final db = await appDatabase.database;

    await expectLater(
      AppDatabase.runMigrations(db, AppDatabase.version, 99),
      throwsStateError,
    );
  });
}
