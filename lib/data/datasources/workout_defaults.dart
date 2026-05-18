import '../../models/exercise.dart';
import '../../models/exercise_media.dart';
import '../../models/workout_plan.dart';
import '../../core/utils/id_generator.dart';

class WorkoutDefaults {
  static ExerciseMedia assetImg(String name) => ExerciseMedia(
    type: ExerciseMediaType.image,
    source: 'assets/images/exercises/$name',
    isLocal: true,
  );

  static List<Exercise> warmupExercises() {
    return [
      Exercise(
        id: IdGenerator.generate(),
        name: 'رول کف پا',
        sets: 1,
        repsOrDuration: 180,
        isTimeBased: true,
        restTime: 15,
        equipment: 'وزن بدن',
        media: assetImg('foot_roll.webp'),
      ),
      Exercise(
        id: IdGenerator.generate(),
        name: 'Monster Walk با مینی‌لوپ',
        sets: 3,
        repsOrDuration: 30,
        isTimeBased: false,
        restTime: 45,
        equipment: 'کش ورزشی',
        description: 'فعال‌سازی لگن',
        media: assetImg('monster_walk.webp'),
      ),
      Exercise(
        id: IdGenerator.generate(),
        name: 'Cat-Cow',
        sets: 1,
        repsOrDuration: 120,
        isTimeBased: true,
        restTime: 15,
        equipment: 'وزن بدن',
        description: 'متحرک‌سازی ستون فقرات',
        media: assetImg('cat_cow.webp'),
      ),
      Exercise(
        id: IdGenerator.generate(),
        name: 'Clamshell با مینی‌لوپ',
        sets: 2,
        repsOrDuration: 30,
        isTimeBased: false,
        restTime: 45,
        equipment: 'کش ورزشی',
        description: 'ثبات زانو',
        media: assetImg('clamshell.webp'),
      ),
    ];
  }

  static WorkoutDay createDay1() {
    return WorkoutDay(
      id: IdGenerator.generate(),
      name: 'قدرت پا و ثبات زنجیره خلفی',
      orderIndex: 0,
      exercises: [
        ...warmupExercises(),
        Exercise(
          id: IdGenerator.generate(),
          name: 'اسکات گابلت (۱۷.۵ ک‌گ)',
          sets: 4,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'تمرکز: VMO',
          media: assetImg('goblet_squat.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'ددلیفت تک پا (۱۰ ک‌گ)',
          sets: 4,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'تمرکز: همسترینگ و مچ پا',
          media: assetImg('single_leg_deadlift.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'لانژ معکوس (۸ ک‌گ)',
          sets: 3,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 60,
          equipment: 'دمبل',
          description: 'تمرکز: ثبات زانو',
          media: assetImg('reverse_lunge.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'پل باسن با مینی‌لوپ',
          sets: 3,
          repsOrDuration: 20,
          isTimeBased: false,
          restTime: 60,
          equipment: 'کش ورزشی',
          description: 'تمرکز: گلوتئوس ماکسیموس',
          media: assetImg('glute_bridge.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'ساق پا ایستاده با دمبل',
          sets: 3,
          repsOrDuration: 20,
          isTimeBased: false,
          restTime: 45,
          equipment: 'دمبل',
          description: 'تقویت عضلات مچ پا',
          media: assetImg('calf_raise.webp'),
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    );
  }

  static WorkoutDay createDay2() {
    return WorkoutDay(
      id: IdGenerator.generate(),
      name: 'هایپرتروفی شانه و اصلاح قوز',
      orderIndex: 1,
      exercises: [
        ...warmupExercises(),
        Exercise(
          id: IdGenerator.generate(),
          name: 'پرس سرشانه نشسته (۱۷.۵ ک‌گ)',
          sets: 4,
          repsOrDuration: 10,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'قدرتی',
          media: assetImg('shoulder_press.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'نشر جانب دمبل (۵ ک‌گ)',
          sets: 4,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 60,
          equipment: 'دمبل',
          description: 'هایپرتروفی دلتوئید میانی',
          media: assetImg('lateral_raise.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'نشر خم دمبل (۸ ک‌گ)',
          sets: 4,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 60,
          equipment: 'دمبل',
          description: 'اصلاح قوز - دلتوئید خلفی',
          media: assetImg('rear_delt_fly.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'فیس‌پول با مینی‌لوپ',
          sets: 4,
          repsOrDuration: 20,
          isTimeBased: false,
          restTime: 45,
          equipment: 'کش ورزشی',
          description: 'اصلاح وضعیت گردن',
          media: assetImg('face_pull.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'شنا سوئدی',
          sets: 3,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 60,
          equipment: 'وزن بدن',
          description: 'تقویت سینه و ثبات کتف',
          media: assetImg('push_up.webp'),
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    );
  }

  static WorkoutDay createDay3() {
    return WorkoutDay(
      id: IdGenerator.generate(),
      name: 'قدرت مرکزی و اصلاح لگن',
      orderIndex: 2,
      exercises: [
        ...warmupExercises(),
        Exercise(
          id: IdGenerator.generate(),
          name: 'اسکات سومو (۱۷.۵ ک‌گ)',
          sets: 4,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'تمرکز: آداکتورها/داخل ران',
          media: assetImg('sumo_squat.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'پلانک شکم',
          sets: 4,
          repsOrDuration: 60,
          isTimeBased: true,
          restTime: 45,
          equipment: 'وزن بدن',
          media: assetImg('plank.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'پلانک پهلو',
          sets: 3,
          repsOrDuration: 45,
          isTimeBased: true,
          restTime: 45,
          equipment: 'وزن بدن',
          media: assetImg('side_plank.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'ددباگ (Dead Bug)',
          sets: 3,
          repsOrDuration: 16,
          isTimeBased: false,
          restTime: 45,
          equipment: 'وزن بدن',
          description: 'اصلاح کمر و لگن',
          media: assetImg('dead_bug.webp'),
        ),
        Exercise(
          id: IdGenerator.generate(),
          name: 'پارویی دمبل تک‌دست (۱۷.۵ ک‌گ)',
          sets: 4,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'اصلاح تقارن کمر',
          media: assetImg('one_arm_row.webp'),
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    );
  }

  static WorkoutPlan defaultPlan() {
    return WorkoutPlan(
      id: IdGenerator.generate(),
      name: 'برنامه تخصصی ۳ روزه',
      description: 'برنامه‌ای ترکیبی برای قدرت پا، هایپرتروفی شانه و قدرت مرکزی با تمرکز بر اصلاح ساختار و پیشگیری از آسیب',
      days: [createDay1(), createDay2(), createDay3()],
      createdAt: DateTime.now(),
      isActive: true,
    );
  }
}
