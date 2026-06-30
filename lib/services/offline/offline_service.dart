import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

/// Service quản lý offline mode.
class OfflineService {
  OfflineService() {
    _init();
  }

  Database? _db;
  bool _isOffline = false;

  Future<void> _init() async {
    Connectivity().onConnectivityChanged.listen(_handleConnectivityChange);
    final result = await Connectivity().checkConnectivity();
    _handleConnectivityChange(result);
    await _initDatabase();
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final wasOffline = _isOffline;
    _isOffline = results.contains(ConnectivityResult.none);
    
    if (_isOffline && !wasOffline) {
      debugPrint('App went offline');
    } else if (!_isOffline && wasOffline) {
      debugPrint('App went online');
      _syncPendingData();
    }
  }

  bool get isOffline => _isOffline;

  Future<bool> hasInternet() async {
    if (_isOffline) return false;
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final dbPathJoin = '$dbPath/deutschtiger_offline.db';
    
    _db = await openDatabase(
      dbPathJoin,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE words (
            id TEXT PRIMARY KEY,
            word TEXT NOT NULL,
            translation TEXT NOT NULL,
            cefr_level TEXT,
            synced INTEGER DEFAULT 0
          )
        ''');
        
        await db.execute('''
          CREATE TABLE reviews (
            id TEXT PRIMARY KEY,
            word_id TEXT NOT NULL,
            rating INTEGER NOT NULL,
            reviewed_at TEXT NOT NULL,
            synced INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<void> saveWordOffline(Map<String, dynamic> word) async {
    if (_db == null) return;
    await _db!.insert('words', {...word, 'synced': 0}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getOfflineWords() async {
    if (_db == null) return [];
    return await _db!.query('words');
  }

  Future<void> _syncPendingData() async {
    if (_db == null || _isOffline) return;
    debugPrint('Syncing pending data...');
  }

  Future<void> dispose() async {
    await _db?.close();
  }
}

final offlineServiceProvider = Provider<OfflineService>((ref) {
  final service = OfflineService();
  ref.onDispose(() => service.dispose());
  return service;
});

class IsOfflineNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  
  void setOffline(bool offline) => state = offline;
}

final isOfflineProvider = NotifierProvider<IsOfflineNotifier, bool>(IsOfflineNotifier.new);
