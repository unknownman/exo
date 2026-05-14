import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/utils.dart';

class SetTimerWidget extends StatefulWidget {
  final int durationSeconds;
  final bool isRunning;
  final VoidCallback onComplete;

  const SetTimerWidget({
    super.key,
    required this.durationSeconds,
    this.isRunning = false,
    required this.onComplete,
  });

  @override
  State<SetTimerWidget> createState() => _SetTimerWidgetState();
}

class _SetTimerWidgetState extends State<SetTimerWidget> {
  late int _secondsLeft;
  Timer? _timer;
  double _progress = 1.0;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.durationSeconds;
    if (widget.isRunning) _start();
  }

  @override
  void didUpdateWidget(SetTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning && !oldWidget.isRunning) _start();
    if (!widget.isRunning && oldWidget.isRunning) _stop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _secondsLeft = widget.durationSeconds;
    _progress = 1.0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        HapticFeedback.heavyImpact();
        setState(() {
          _secondsLeft = 0;
          _progress = 0;
        });
        widget.onComplete();
        return;
      }
      setState(() {
        _secondsLeft--;
        _progress = _secondsLeft / widget.durationSeconds;
      });
      if (_secondsLeft <= 3 && _secondsLeft > 0) {
        HapticFeedback.lightImpact();
      }
    });
  }

  void _stop() {
    _timer?.cancel();
  }

  void skip() {
    _timer?.cancel();
    HapticFeedback.heavyImpact();
    setState(() {
      _secondsLeft = 0;
      _progress = 0;
    });
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLow = _secondsLeft <= 3;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: CircularProgressIndicator(
                  value: _progress,
                  strokeWidth: 12,
                  backgroundColor: cs.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isLow ? Colors.red : cs.primary,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppUtils.formatDuration(Duration(seconds: _secondsLeft)),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                          color: isLow ? Colors.red : cs.onSurface,
                        ),
                  ),
                  Text(
                    'باقی مانده',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.5),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
