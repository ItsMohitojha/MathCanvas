import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'database_migrations.dart';
import 'package:mathcanvas/core/logging/app_logger.dart';

final _logger = AppLogger('DatabaseProvider');

final databaseProvider = Provider<Future<Database>>((ref) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'mathcanvas.db');
  
  return openDatabase(
    path,
    version: DatabaseMigrations.currentVersion,
    onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON;');
      await db.execute('PRAGMA journal_mode = WAL;');
    },
    onCreate: (db, version) async {
      _logger.info('Creating SQLite database...');
      await DatabaseMigrations.migrate(db, 0, version);
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      _logger.info('Upgrading SQLite database from $oldVersion to $newVersion...');
      await DatabaseMigrations.migrate(db, oldVersion, newVersion);
    },
  );
});
