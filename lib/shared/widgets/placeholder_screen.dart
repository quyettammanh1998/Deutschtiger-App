import 'package:flutter/material.dart';

/// Màn hình tạm cho các tab chưa implement ở P0.
/// Sẽ được thay bằng screen thật trong các phase P1–P5.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title, this.icon});

  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon ?? Icons.construction, size: 48),
            const SizedBox(height: 12),
            Text('$title — đang phát triển'),
          ],
        ),
      ),
    );
  }
}
