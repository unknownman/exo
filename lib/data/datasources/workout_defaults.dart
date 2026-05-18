import '../../models/exercise.dart';
import '../../models/workout_plan.dart';

class WorkoutDefaults {
  static List<Exercise> warmupExercises() {
    return [
      Exercise(
        id: 'ex_warm_1',
        name: 'رول کف پا',
        sets: 1,
        repsOrDuration: 180,
        isTimeBased: true,
        restTime: 15,
        equipment: 'وزن بدن',
      ),
      Exercise(
        id: 'ex_warm_2',
        name: 'Monster Walk با مینی‌لوپ',
        sets: 3,
        repsOrDuration: 30,
        isTimeBased: false,
        restTime: 45,
        equipment: 'کش ورزشی',
        description: 'فعال‌سازی لگن',
      ),
      Exercise(
        id: 'ex_warm_3',
        name: 'Cat-Cow',
        sets: 1,
        repsOrDuration: 120,
        isTimeBased: true,
        restTime: 15,
        equipment: 'وزن بدن',
        description: 'متحرک‌سازی ستون فقرات',
      ),
      Exercise(
        id: 'ex_warm_4',
        name: 'Clamshell با مینی‌لوپ',
        sets: 2,
        repsOrDuration: 30,
        isTimeBased: false,
        restTime: 45,
        equipment: 'کش ورزشی',
        description: 'ثبات زانو',
      ),
    ];
  }

  static WorkoutDay createDay1() {
    return WorkoutDay(
      id: 'exo_pro_day_1',
      name: 'قدرت پا و ثبات زنجیره خلفی',
      orderIndex: 0,
      exercises: [
        ...warmupExercises(),
        Exercise(
          id: 'ex_d1_1',
          name: 'اسکات گابلت (۱۷.۵ ک‌گ)',
          sets: 4,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'تمرکز: VMO',
        ),
        Exercise(
          id: 'ex_d1_2',
          name: 'ددلیفت تک پا (۱۰ ک‌گ)',
          sets: 4,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'تمرکز: همسترینگ و مچ پا',
        ),
        Exercise(
          id: 'ex_d1_3',
          name: 'لانژ معکوس (۸ ک‌گ)',
          sets: 3,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 60,
          equipment: 'دمبل',
          description: 'تمرکز: ثبات زانو',
        ),
        Exercise(
          id: 'ex_d1_4',
          name: 'پل باسن با مینی‌لوپ',
          sets: 3,
          repsOrDuration: 20,
          isTimeBased: false,
          restTime: 60,
          equipment: 'کش ورزشی',
          description: 'تمرکز: گلوتئوس ماکسیموس',
        ),
        Exercise(
          id: 'ex_d1_5',
          name: 'ساق پا ایستاده با دمبل',
          sets: 3,
          repsOrDuration: 20,
          isTimeBased: false,
          restTime: 45,
          equipment: 'دمبل',
          description: 'تقویت عضلات مچ پا',
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    );
  }

  static WorkoutDay createDay2() {
    return WorkoutDay(
      id: 'exo_pro_day_2',
      name: 'هایپرتروفی شانه و اصلاح قوز',
      orderIndex: 1,
      exercises: [
        ...warmupExercises(),
        Exercise(
          id: 'ex_d2_1',
          name: 'پرس سرشانه نشسته (۱۷.۵ ک‌گ)',
          sets: 4,
          repsOrDuration: 10,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'قدرتی',
        ),
        Exercise(
          id: 'ex_d2_2',
          name: 'نشر جانب دمبل (۵ ک‌گ)',
          sets: 4,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 60,
          equipment: 'دمبل',
          description: 'هایپرتروفی دلتوئید میانی',
        ),
        Exercise(
          id: 'ex_d2_3',
          name: 'نشر خم دمبل (۸ ک‌گ)',
          sets: 4,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 60,
          equipment: 'دمبل',
          description: 'اصلاح قوز - دلتوئید خلفی',
        ),
        Exercise(
          id: 'ex_d2_4',
          name: 'فیس‌پول با مینی‌لوپ',
          sets: 4,
          repsOrDuration: 20,
          isTimeBased: false,
          restTime: 45,
          equipment: 'کش ورزشی',
          description: 'اصلاح وضعیت گردن',
        ),
        Exercise(
          id: 'ex_d2_5',
          name: 'شنا سوئدی',
          sets: 3,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 60,
          equipment: 'وزن بدن',
          description: 'تقویت سینه و ثبات کتف',
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    );
  }

  static WorkoutDay createDay3() {
    return WorkoutDay(
      id: 'exo_pro_day_3',
      name: 'قدرت مرکزی و اصلاح لگن',
      orderIndex: 2,
      exercises: [
        ...warmupExercises(),
        Exercise(
          id: 'ex_d3_1',
          name: 'اسکات سومو (۱۷.۵ ک‌گ)',
          sets: 4,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'تمرکز: آداکتورها/داخل ران',
        ),
        Exercise(
          id: 'ex_d3_2',
          name: 'پلانک شکم',
          sets: 4,
          repsOrDuration: 60,
          isTimeBased: true,
          restTime: 45,
          equipment: 'وزن بدن',
        ),
        Exercise(
          id: 'ex_d3_3',
          name: 'پلانک پهلو',
          sets: 3,
          repsOrDuration: 45,
          isTimeBased: true,
          restTime: 45,
          equipment: 'وزن بدن',
        ),
        Exercise(
          id: 'ex_d3_4',
          name: 'ددباگ (Dead Bug)',
          sets: 3,
          repsOrDuration: 16,
          isTimeBased: false,
          restTime: 45,
          equipment: 'وزن بدن',
          description: 'اصلاح کمر و لگن',
        ),
        Exercise(
          id: 'ex_d3_5',
          name: 'پارویی دمبل تک‌دست (۱۷.۵ ک‌گ)',
          sets: 4,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'اصلاح تقارن کمر',
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    );
  }

  static WorkoutPlan defaultPlan() {
    return WorkoutPlan(
      id: 'exo_pro',
      name: 'برنامه تخصصی ۳ روزه',
      description: 'برنامه‌ای ترکیبی برای قدرت پا، هایپرتروفی شانه و قدرت مرکزی با تمرکز بر اصلاح ساختار و پیشگیری از آسیب',
      days: [createDay1(), createDay2(), createDay3()],
      createdAt: DateTime.now(),
      isActive: true,
    );
  }
}
