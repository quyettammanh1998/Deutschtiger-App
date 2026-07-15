import 'package:flutter/material.dart';

/// Root navigator key — exposed để global code (vd. [ApiClient] khi gặp
/// device-kicked 401) có thể push dialog / navigate từ bất kỳ đâu mà không
/// cần BuildContext. Key này KHÔNG thay đổi sau khi tạo và được gắn vào
/// [GoRouter] trong `app_router.dart`.
///
/// File tách riêng để tránh import cycle giữa `view_models/providers.dart`
/// (cần key cho ApiClient device-kicked handler) và `navigation/app_router.dart`
/// (cần key cho GoRouter, đồng thời import providers cho authServiceProvider).
final rootNavigatorKey = GlobalKey<NavigatorState>();
