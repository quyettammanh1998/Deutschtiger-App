import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef ConnectivityChecker = Future<List<ConnectivityResult>> Function();

/// Connectivity state for the online-first mobile app.
///
/// No learning data or writes are persisted for offline replay. The backend
/// does not yet define an idempotent outbox and conflict contract, so pretending
/// to queue reviews would risk data loss or duplicate progress.
class OfflineService {
  OfflineService({
    Stream<List<ConnectivityResult>>? connectivityChanges,
    ConnectivityChecker? checkConnectivity,
  }) : _connectivityChanges =
           connectivityChanges ?? Connectivity().onConnectivityChanged,
       _checkConnectivity =
           checkConnectivity ?? Connectivity().checkConnectivity {
    _init();
  }

  final Stream<List<ConnectivityResult>> _connectivityChanges;
  final ConnectivityChecker _checkConnectivity;
  bool _isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final StreamController<bool> _statusController =
      StreamController<bool>.broadcast();

  Future<void> _init() async {
    _connectivitySubscription = _connectivityChanges.listen(
      _handleConnectivityChange,
    );
    final result = await _checkConnectivity();
    _handleConnectivityChange(result);
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final wasOffline = _isOffline;
    _isOffline = results.contains(ConnectivityResult.none);

    if (_isOffline != wasOffline) {
      _statusController.add(_isOffline);
    }

    if (_isOffline && !wasOffline) {
      debugPrint('App went offline');
    } else if (!_isOffline && wasOffline) {
      debugPrint('App went online');
    }
  }

  bool get isOffline => _isOffline;
  Stream<bool> get statusStream => _statusController.stream;

  Future<bool> hasInternet() async {
    if (_isOffline) return false;
    final result = await _checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
    await _statusController.close();
  }
}

final offlineServiceProvider = Provider<OfflineService>((ref) {
  final service = OfflineService();
  ref.onDispose(() => service.dispose());
  return service;
});

final isOfflineProvider = StreamProvider<bool>((ref) async* {
  final service = ref.watch(offlineServiceProvider);
  yield service.isOffline;
  yield* service.statusStream;
});
