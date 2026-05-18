import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/models/exercise.dart';
import 'package:exo/models/exercise_media.dart';
import 'package:exo/providers/active_workout_provider.dart';
import 'package:exo/core/theme/app_theme.dart';
import 'package:exo/widgets/exercise_media_widget.dart';
import 'package:exo/core/constants/app_strings.dart';
import 'package:exo/core/utils/persian_digits.dart';

class RestScreen extends ConsumerStatefulWidget {
  const RestScreen({super.key});

  @override
  ConsumerState<RestScreen> createState() => _RestScreenState();
}

class _RestScreenState extends ConsumerState<RestScreen> {
  @override
  Widget build(BuildContext context) {
    final remaining = ref.watch(
      activeWorkoutNotifierProvider.select((s) => s.remainingRestSeconds),
    );
    final total = ref.watch(
      activeWorkoutNotifierProvider.select((s) => s.totalRestSeconds),
    );
    final nextExercise = ref.watch(
      activeWorkoutNotifierProvider.select((s) => s.nextExerciseSnapshot),
    );
    final nextSet = ref.watch(
      activeWorkoutNotifierProvider.select((s) => s.nextSetNumber),
    );
    final isResting = ref.watch(
      activeWorkoutNotifierProvider.select((s) => s.isResting),
    );

    if (!isResting) {
      return const SizedBox.shrink();
    }

    final progress = total > 0 ? remaining / total : 0.0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: PopScope(
        canPop: false,
        child: Scaffold(
        backgroundColor: AppTheme.tealDark,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const Text(
                  AppStrings.restTime,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                _buildTimerWithRing(remaining, progress),
                const Spacer(flex: 1),
                if (nextExercise != null) _buildNextUp(nextExercise, nextSet),
                const Spacer(flex: 2),
                _buildActions(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildTimerWithRing(int remaining, double progress) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 220,
            height: 220,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 6,
              backgroundColor: Colors.white.withAlpha(30),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.tealLight,
              ),
              strokeCap: StrokeCap.round,
            ),
          ),
          Text(
            formatWorkoutTime(remaining),
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w200,
              color: Colors.white,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextUp(Exercise exercise, int? nextSet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (exercise.media.type != ExerciseMediaType.none)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 64,
                height: 64,
                child: ExerciseMediaWidget(
                  media: exercise.media,
                  fit: BoxFit.cover,
                  width: 64,
                  height: 64,
                ),
              ),
            )
          else
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.fitness_center,
                color: Colors.white54,
                size: 32,
              ),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.nextExercise,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  exercise.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (nextSet != null) ...[
                  const SizedBox(height: 2),
                    Text(
                      'ست ${nextSet.toPersian()} از ${exercise.sets.toPersian()}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    final provider = ref.read(activeWorkoutNotifierProvider.notifier);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => provider.addRestTime(20),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              AppStrings.add20Seconds,
              style: TextStyle(color: Colors.white),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white54),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => provider.skipRest(),
            icon: const Icon(Icons.skip_next),
            label: const Text(
              AppStrings.skipRest,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.tealPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
