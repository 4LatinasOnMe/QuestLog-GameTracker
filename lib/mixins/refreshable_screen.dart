import 'package:flutter/material.dart';

/// Mixin for screens that need to refresh when becoming visible
mixin RefreshableScreen<T extends StatefulWidget> on State<T> {
  /// Override this method to implement refresh logic
  void onScreenVisible();
  
  /// Call this when the screen becomes visible
  void notifyVisible() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        onScreenVisible();
      }
    });
  }
}
