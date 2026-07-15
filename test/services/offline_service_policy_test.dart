import 'dart:io';

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:deutschtiger/services/offline/offline_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('offline service does not persist or queue learning writes', () {
    final source = File(
      'lib/services/offline/offline_service.dart',
    ).readAsStringSync();

    expect(source, isNot(contains('package:sqflite')));
    expect(source, isNot(contains('saveWordOffline')));
    expect(source, isNot(contains('_syncPendingData')));
  });

  test('reports connectivity changes without queuing writes', () async {
    final changes = StreamController<List<ConnectivityResult>>();
    var snapshot = <ConnectivityResult>[ConnectivityResult.wifi];
    final service = OfflineService(
      connectivityChanges: changes.stream,
      checkConnectivity: () async => snapshot,
    );
    final statuses = <bool>[];
    final subscription = service.statusStream.listen(statuses.add);
    await _flushEvents();

    expect(service.isOffline, isFalse);
    expect(await service.hasInternet(), isTrue);

    changes.add(const [ConnectivityResult.none]);
    await _flushEvents();
    expect(service.isOffline, isTrue);

    snapshot = <ConnectivityResult>[ConnectivityResult.none];
    expect(await service.hasInternet(), isFalse);

    changes.add(const [ConnectivityResult.mobile]);
    await _flushEvents();
    expect(service.isOffline, isFalse);
    expect(statuses, [true, false]);

    await subscription.cancel();
    await changes.close();
    await service.dispose();
  });
}

Future<void> _flushEvents() => Future<void>.delayed(Duration.zero);
