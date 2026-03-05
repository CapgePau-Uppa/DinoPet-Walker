import 'dart:math';
import 'package:flutter/material.dart';


class JumpAnimation {
  final TickerProvider vsync;

  late final AnimationController _jump;

  bool _disposed = false;

  JumpAnimation({required this.vsync}) {
    _jump = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    _scheduleNextJump();
  }

  Animation<double> get jump => _jump;

  double get idleJumpOffsetY {
    if (!_jump.isAnimating) return 0.0;
    return -20.0 * sin(_jump.value * pi);
  }

  void _scheduleNextJump() {
    final delay = 4000 + Random().nextInt(3000);
    Future.delayed(Duration(milliseconds: delay), () {
      if (_disposed) return;
      _jump.forward(from: 0).then((_) => _scheduleNextJump());
    });
  }

  void dispose() {
    _disposed = true;
    _jump.dispose();
  }
}
