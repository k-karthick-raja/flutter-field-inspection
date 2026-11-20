/// Schema migrations, keyed by the database version they upgrade *to*.
///
/// Never edit a migration that has shipped. Add a new version instead and
/// bump [AppDatabase.version].
const Map<int, List<String>> migrations = {
  1: [
    '''
    CREATE TABLE sites (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      address TEXT NOT NULL
    )
    ''',
    '''
    CREATE TABLE inspections (
      id TEXT PRIMARY KEY,
      site_id TEXT NOT NULL REFERENCES sites(id) ON DELETE CASCADE,
      title TEXT NOT NULL,
      status TEXT NOT NULL,
      scheduled_for TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
    ''',
    '''
    CREATE TABLE checklist_items (
      id TEXT PRIMARY KEY,
      inspection_id TEXT NOT NULL
        REFERENCES inspections(id) ON DELETE CASCADE,
      label TEXT NOT NULL,
      is_required INTEGER NOT NULL DEFAULT 1,
      answer TEXT NOT NULL DEFAULT 'unanswered',
      note TEXT
    )
    ''',
    'CREATE INDEX idx_inspections_site ON inspections(site_id)',
    'CREATE INDEX idx_items_inspection ON checklist_items(inspection_id)',
  ],
};
