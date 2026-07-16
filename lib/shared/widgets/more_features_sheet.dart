import 'package:flutter/widgets.dart';

import 'more_features/more_features_dialog.dart';

/// Public entry point for the "Thêm" tab's overflow catalog, opened from
/// [AppShell]. Web parity: a CENTERED scale-in dialog (`more-features-sheet.tsx`
/// via `BottomSheet centered=true`), not a bottom-anchored sheet — see
/// [MoreFeaturesDialog] for the implementation (split out with the tile
/// catalog to stay under the file-size guideline).
abstract final class MoreFeaturesSheet {
  static Future<void> show(BuildContext context) =>
      MoreFeaturesDialog.show(context);
}
