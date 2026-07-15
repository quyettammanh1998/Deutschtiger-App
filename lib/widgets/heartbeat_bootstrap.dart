import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/heartbeat/heartbeat_provider.dart';

/// Hidden widget that activates the heartbeat notifier on mount.
/// Drop inside the HomeScreen tree — returns SizedBox.shrink().
class HeartbeatBootstrap extends ConsumerWidget {
  const HeartbeatBootstrap({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (enabled) ref.watch(heartbeatProvider);
    return const SizedBox.shrink();
  }
}
