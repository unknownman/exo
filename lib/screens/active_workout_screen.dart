import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exo/models/exercise.dart';
import 'package:exo/models/workout_day.dart';
import 'package:exo/providers/workout_provider.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  final WorkoutDay day;
  const ActiveWorkoutScreen({super.key, required this.day});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  late int _currentExerciseIndex;
  late int _currentSet;
  bool _isResting = false;
  bool _isWorkoutTimerRunning = false;
  int _remainingWorkoutSeconds = 0;
  int _remainingRestSeconds = 0;
  Timer? _timer;
  bool _allDone = false;

  @override
  void initState() {
    super.initState();
    _currentExerciseIndex = 0;
    _currentSet = 1;
    _resetWorkoutTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Exercise get _currentExercise =>
      widget.day.exercises[_currentExerciseIndex];

  void _resetWorkoutTimer() {
    if (_currentExercise.isTimeBased) {
      _remainingWorkoutSeconds = _currentExercise.repsOrDuration;
      _isWorkoutTimerRunning = false;
    }
  }

  void _startTimer(void Function() onComplete, int seconds) {
    _timer?.cancel();
    _remainingRestSeconds = seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _remainingRestSeconds--;
      });
      if (_remainingRestSeconds <= 0) {
        t.cancel();
        onComplete();
      }
    });
  }

  void _toggleWorkoutTimer() {
    if (_isWorkoutTimerRunning) {
      _timer?.cancel();
      _isWorkoutTimerRunning = false;
    } else {
      _isWorkoutTimerRunning = true;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        setState(() {
          _remainingWorkoutSeconds--;
        });
        if (_remainingWorkoutSeconds <= 0) {
          t.cancel();
          _startRest();
        }
      });
    }
    setState(() {});
  }

  void _finishSet() {
    _timer?.cancel();
    if (_currentSet < _currentExercise.sets) {
      _startRest();
    } else {
      _nextExercise();
    }
  }

  void _startRest() {
    setState(() {
      _isResting = true;
      _remainingRestSeconds = _currentExercise.restTime;
      _isWorkoutTimerRunning = false;
    });
    _startTimer(_onRestEnd, _currentExercise.restTime);
  }

  void _onRestEnd() {
    setState(() {
      _isResting = false;
    });
    if (_currentSet < _currentExercise.sets) {
      setState(() {
        _currentSet++;
        _resetWorkoutTimer();
      });
    } else {
      _nextExercise();
    }
  }

  void _skipRest() {
    _timer?.cancel();
    _onRestEnd();
  }

  void _nextExercise() {
    if (_currentExerciseIndex + 1 < widget.day.exercises.length) {
      setState(() {
        _currentExerciseIndex++;
        _currentSet = 1;
        _isResting = false;
        _resetWorkoutTimer();
      });
    } else {
      setState(() {
        _allDone = true;
        _isResting = false;
      });
    }
  }

  void _finishWorkout() {
    context.read<WorkoutProvider>().completeDay(widget.day.id);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.day.dayName)),
        body: _allDone ? _buildDoneView() : _buildWorkoutView(),
      ),
    );
  }

  Widget _buildDoneView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.celebration, size: 80, color: Colors.green),
          const SizedBox(height: 16),
          const Text(
            'تمرین امروز با موفقیت انجام شد!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _finishWorkout,
            icon: const Icon(Icons.check),
            label: const Text('ثبت و پایان تمرین امروز'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutView() {
    return Container(
      color: _isResting ? Colors.blue[50] : null,
      child: Column(
        children: [
          if (_isResting) _buildRestBanner(),
          Expanded(child: _buildExerciseSection()),
        ],
      ),
    );
  }

  Widget _buildRestBanner() {
    return Container(
      width: double.infinity,
      color: Colors.blue[100],
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        children: [
          const Text(
            'زمان استراحت',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _formatTime(_remainingRestSeconds),
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _skipRest,
            child: const Text('رد کردن استراحت'),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseSection() {
    final ex = _currentExercise;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            ex.equipment == 'وزن بدن'
                ? Icons.directions_walk
                : ex.equipment == 'دمبل'
                    ? Icons.fitness_center
                    : ex.equipment == 'هالتر'
                        ? Icons.fitness_center
                        : ex.equipment == 'کش ورزشی'
                            ? Icons.architecture
                            : Icons.precision_manufacturing,
            size: 64,
            color: Colors.blueGrey,
          ),
          const SizedBox(height: 16),
          Text(ex.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('تجهیزات: ${ex.equipment}',
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 24),
          Text(
            'ست $_currentSet از ${ex.sets}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 32),
          if (ex.isTimeBased) _buildTimerSection() else _buildRepsSection(),
        ],
      ),
    );
  }

  Widget _buildTimerSection() {
    return Column(
      children: [
        Text(
          _formatTime(_remainingWorkoutSeconds),
          style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w200),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _toggleWorkoutTimer,
          icon: Icon(_isWorkoutTimerRunning ? Icons.pause : Icons.play_arrow),
          label: Text(_isWorkoutTimerRunning ? 'توقف' : 'شروع'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildRepsSection() {
    return ElevatedButton.icon(
      onPressed: _finishSet,
      icon: const Icon(Icons.check),
      label: const Text('پایان این ست'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      ),
    );
  }
}
