import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_strings.dart';
import '../../core/errors/failure.dart';
import '../../core/local_db/daos/workout_dao.dart';
import '../../core/utils/id_generator.dart';
import '../../data/datasources/workout_defaults.dart';
import '../../models/exercise.dart';
import '../../models/exercise_media.dart';
import '../../models/workout_log.dart';
import '../../models/workout_plan.dart';

part 'recommendation_service.g.dart';

class RecommendationService {
  final WorkoutDao _workoutDao;
  int _remainingCredits = 5;

  RecommendationService({
    required WorkoutDao workoutDao,
  }) : _workoutDao = workoutDao;

  bool hasEnoughCredits() => _remainingCredits > 0;

  void deductCredit() {
    if (_remainingCredits > 0) _remainingCredits--;
  }

  Future<Result<bool>> hasEnoughWorkoutData() async {
    try {
      final logs = await _workoutDao.getAllLogs();
      if (logs.length < 3) {
        return const Success(false);
      }
      return const Success(true);
    } catch (e) {
      return Success(false);
    }
  }

  Future<Result<List<WorkoutLog>>> prepareAIRequest() async {
    try {
      final logs = await _workoutDao.getAllLogs();
      final recent = logs.take(10).toList();
      final result = <WorkoutLog>[];
      for (final logData in recent) {
        final sets = await _workoutDao.getSetsByLog(logData.id);
        result.add(WorkoutLog(
          id: logData.id,
          dayId: logData.dayId,
          dayName: logData.dayName,
          completedAt: logData.completedAt,
          exerciseCount: 0,
          totalSets: sets.where((s) => s.isCompleted).length,
          totalDurationMinutes: logData.durationMinutes,
          exercises: [],
        ));
      }
      return Success(result);
    } catch (e) {
      return Error(DatabaseFailure('${AppStrings.databaseLoadError} ${e.toString()}'));
    }
  }

  Future<Result<WorkoutPlan>> generateRecommendation() async {
    if (!hasEnoughCredits()) {
      return Error(const InsufficientCreditsFailure(AppStrings.aiNoCredits));
    }

    final dataCheck = await hasEnoughWorkoutData();
    if (dataCheck is Success<bool> && !dataCheck.data) {
      return Error(
        const InsufficientCreditsFailure(AppStrings.aiNotEnoughData),
      );
    }

    await Future.delayed(const Duration(seconds: 2));

    deductCredit();

    final plan = _buildMockAIPlan();
    return Success(plan);
  }

  WorkoutPlan _buildMockAIPlan() {
    final planId = IdGenerator.generate();

    return WorkoutPlan(
      id: planId,
      name: AppStrings.aiPlanName,
      description: AppStrings.aiPlanDescription,
      days: [
        _createAIDay1(planId),
        _createAIDay2(planId),
        _createAIDay3(planId),
        _createAIDay4(planId),
      ],
      createdAt: DateTime.now(),
      isActive: false,
      isSynced: false,
    );
  }

  WorkoutDay _createAIDay1(String planId) {
    return WorkoutDay(
      id: IdGenerator.generate(),
      name: '${AppStrings.aiDayPrefix} ۱ - قدرت پایین‌تنه',
      orderIndex: 0,
      exercises: [
        Exercise(
          id: IdGenerator.generate(),
          name: 'اسکات گابلت پیشرفته',
          sets: 4,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 90,
          equipment: 'دمبل',
          description: 'تمرکز بر VMO و عمق حرکت',
          targetMuscles: ['چهارسر ران', 'باسن', 'همسترینگ'],
          media: WorkoutDefaults.assetImg('goblet_squat.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'ددلیفت رومانیایی تک‌پا',
          sets: 3,
          repsOrDuration: 10,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'ثبات مرکزی و قدرت همسترینگ',
          targetMuscles: ['همسترینگ', 'باسن', 'core'],
          media: WorkoutDefaults.assetImg('single_leg_deadlift.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'لانژ جانبی با کش',
          sets: 3,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 60,
          equipment: 'کش ورزشی',
          description: 'تقویت اداکتورها و ثبات لگن',
          targetMuscles: ['اداکتور', 'گلوتئوس مدیوس'],
          media: const ExerciseMedia.empty(),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'پل باسن پیشرفته',
          sets: 3,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 60,
          equipment: 'وزن بدن',
          description: 'فعال‌سازی گلوتئوس ماکسیموس',
          targetMuscles: ['باسن', 'همسترینگ'],
          media: WorkoutDefaults.assetImg('glute_bridge.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'پلانک با ضربات پا',
          sets: 3,
          repsOrDuration: 45,
          isTimeBased: true,
          restTime: 45,
          equipment: 'وزن بدن',
          description: 'ثبات مرکزی و تقویت شانه',
          targetMuscles: ['core', 'شانه'],
          media: WorkoutDefaults.assetImg('plank.webp'),
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    );
  }

  WorkoutDay _createAIDay2(String planId) {
    return WorkoutDay(
      id: IdGenerator.generate(),
      name: '${AppStrings.aiDayPrefix} ۲ - فشار بالاتنه',
      orderIndex: 1,
      exercises: [
        Exercise(
          id: IdGenerator.generate(),
          name: 'پرس سرشانه تک‌دست',
          sets: 4,
          repsOrDuration: 10,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'رفع عدم تقارن شانه',
          targetMuscles: ['دلتوئید قدامی', 'دلتوئید میانی'],
          media: WorkoutDefaults.assetImg('shoulder_press.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'نشر جانب با مکث ثانیه‌ای',
          sets: 4,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 60,
          equipment: 'دمبل',
          description: 'مکث ۲ ثانیه در اوج انقباض',
          targetMuscles: ['دلتوئید میانی'],
          media: WorkoutDefaults.assetImg('lateral_raise.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'فیس‌پول پیشرفته',
          sets: 3,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 45,
          equipment: 'کش ورزشی',
          description: 'اصلاح گوژپشتی و تقویت روتیتور کاف',
          targetMuscles: ['دلتوئید خلفی', 'تراپ', 'روتیتور کاف'],
          media: WorkoutDefaults.assetImg('face_pull.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'شنا سوئدی پرشی',
          sets: 3,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 60,
          equipment: 'وزن بدن',
          description: 'پایین‌رفتن آهسته + بالا آمدن انفجاری',
          targetMuscles: ['سینه', 'شانه', 'سه‌سر بازو'],
          media: WorkoutDefaults.assetImg('push_up.webp'),
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    );
  }

  WorkoutDay _createAIDay3(String planId) {
    return WorkoutDay(
      id: IdGenerator.generate(),
      name: '${AppStrings.aiDayPrefix} ۳ - کشش و پشت',
      orderIndex: 2,
      exercises: [
        Exercise(
          id: IdGenerator.generate(),
          name: 'پارویی دمبل با مکث',
          sets: 4,
          repsOrDuration: 10,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'مکث ۲ ثانیه در اوج',
          targetMuscles: ['لت', 'تراپ', 'دلتوئید خلفی'],
          media: WorkoutDefaults.assetImg('one_arm_row.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'ردیف کش نشسته',
          sets: 3,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 60,
          equipment: 'کش ورزشی',
          description: 'فشار بر روی عضلات میانی کمر',
          targetMuscles: ['رومبوئید', 'تراپ میانی', 'دلتوئید خلفی'],
          media: const ExerciseMedia.empty(),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'ددباگ پیشرفته',
          sets: 3,
          repsOrDuration: 10,
          isTimeBased: false,
          restTime: 45,
          equipment: 'وزن بدن',
          description: 'حرکت آهسته و کنترل شده',
          targetMuscles: ['core', 'فلکسورهای لگن'],
          media: WorkoutDefaults.assetImg('dead_bug.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'سوپرمن با مکث',
          sets: 3,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 45,
          equipment: 'وزن بدن',
          description: '۳ ثانیه مکث در اوج',
          targetMuscles: ['اکستانسور پشت', 'باسن'],
          media: const ExerciseMedia.empty(),
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    );
  }

  WorkoutDay _createAIDay4(String planId) {
    return WorkoutDay(
      id: IdGenerator.generate(),
      name: '${AppStrings.aiDayPrefix} ۴ - تناوبی و هوازی',
      orderIndex: 3,
      exercises: [
        Exercise(
          id: IdGenerator.generate(),
          name: 'برپی پیشرفته',
          sets: 3,
          repsOrDuration: 10,
          isTimeBased: false,
          restTime: 60,
          equipment: 'وزن بدن',
          description: 'حرکت انفجاری',
          targetMuscles: ['تمام بدن', 'سیستم قلبی عروقی'],
          media: const ExerciseMedia.empty(),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'کوهنوردی سریع',
          sets: 3,
          repsOrDuration: 45,
          isTimeBased: true,
          restTime: 45,
          equipment: 'وزن بدن',
          description: 'بالا بردن ضربان قلب',
          targetMuscles: ['core', 'شانه', 'چهارسر ران'],
          media: const ExerciseMedia.empty(),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'اسکات پرشی',
          sets: 3,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 60,
          equipment: 'وزن بدن',
          description: 'توان انفجاری پایین‌تنه',
          targetMuscles: ['چهارسر ران', 'باسن', 'ساق پا'],
          media: WorkoutDefaults.assetImg('sumo_squat.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'پلانک پهلو چرخشی',
          sets: 3,
          repsOrDuration: 10,
          isTimeBased: false,
          restTime: 45,
          equipment: 'وزن بدن',
          description: 'چرخش تنه و ثبات مایل شکم',
          targetMuscles: ['مورب شکم', 'core', 'شانه'],
          media: WorkoutDefaults.assetImg('plank.webp'),
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    );
  }
}

@riverpod
RecommendationService recommendationService(RecommendationServiceRef ref) {
  final workoutDao = ref.watch(workoutDaoProvider);
  return RecommendationService(
    workoutDao: workoutDao,
  );
}
