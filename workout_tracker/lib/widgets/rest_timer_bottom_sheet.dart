import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/utils.dart';

Future<bool> showRestTimerBottomSheet(
  BuildContext context, {
  required int restSeconds,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _RestTimerSheet(restSeconds: restSeconds),
  ).then((v) => v ?? false);
}

class _RestTimerSheet extends StatefulWidget {
  final int restSeconds;

  const _RestTimerSheet({required this.restSeconds});

  @override
  State<_RestTimerSheet> createState() => _RestTimerSheetState();
}

class _RestTimerSheetState extends State<_RestTimerSheet>
    with SingleTickerProviderStateMixin {
  late int _secondsLeft;
  Timer? _timer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.restSeconds;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        HapticFeedback.heavyImpact();
        if (mounted) Navigator.of(context).pop(false);
        return;
      }
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 3) HapticFeedback.lightImpact();
    });
  }

  void _skip() {
    _timer?.cancel();
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLow = _secondsLeft <= 3;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: cs.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final scale = isLow ? 1.0 + (_pulseController.value * 0.05) : 1.0;
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: Icon(
              Icons.hourglass_bottom,
              size: 48,
              color: cs.primary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'استراحت',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: 20),
          Text(
            AppUtils.formatDuration(Duration(seconds: _secondsLeft)),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: isLow ? Colors.red : cs.onSurface,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'تا ست بعدی',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: 200,
            child: OutlinedButton.icon(
              onPressed: _skip,
              icon: const Icon(Icons.skip_next),
              label: const Text('رد کردن استراحت'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
