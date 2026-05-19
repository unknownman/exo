class AppStrings {
  // Error Messages
  static const String databaseLoadError = 'خطا در بارگذاری داده‌ها. برنامه پیش‌فرض بارگذاری شد.';
  static const String databaseSaveError = 'خطا در ذخیره‌سازی اطلاعات در پایگاه داده.';
  static const String unknownError = 'یک خطای ناشناخته رخ داده است.';
  static const String errorWithMessage = 'خطا: ';
  static const String errorTitle = 'خطا';

  // General App Labels
  static const String appName = 'اگزو';


  // Global Actions
  static const String dismiss = 'انصراف';
  static const String confirm = 'ثبت';
  static const String done = 'ثبت و بازگشت';
  static const String delete = 'حذف';
  static const String back = 'بازگشت';
  static const String exit = 'خروج';
  static const String add = 'افزودن';
  static const String completed = 'انجام شد';
  static const String create = 'ایجاد';

  // Units
  static const String second = 'ثانیه';
  static const String rep = 'تکرار';
  static const String set = 'ست';
  static const String minutes = 'دقیقه';

  // Plan & Day Labels
  static const String editPlan = 'ویرایش برنامه';
  static const String createNewPlan = 'ایجاد برنامه جدید';
  static const String planNameInput = 'نام برنامه';
  static const String dayNameInput = 'نام روز';
  static const String exerciseNameInput = 'نام تمرین';
  static const String exerciseCount = 'تعداد حرکات';
  static const String duration = 'مدت زمان';
  static const String rest = 'استراحت';
  static const String restTime = 'زمان استراحت';
  static const String nextExercise = 'بعدی';
  static const String add20Seconds = '۲۰+ ثانیه';
  static const String skipRest = 'رد کردن';

  // ===================== Shell =====================
  static const String tabDashboard = 'داشبورد';
  static const String tabHistory = 'تاریخچه';
  static const String tabEditor = 'ویرایشگر';
  static const String tabProfile = 'پروفایل';

  // ===================== Dashboard =====================
  static const String dashboardTitle = 'داشبورد';
  static const String noPlanYet = 'هنوز برنامه‌ای ندارید';
  static const String startWorkout = 'شروع تمرین';
  static const String noExercisesForDay = 'هیچ تمرینی برای این روز ثبت نشده';
  static const String addExerciseHint = 'با دکمه + تمرین اضافه کنید';

  // ===================== Active Workout =====================
  static const String workoutFallbackName = 'تمرین';
  static const String workoutComplete = 'آفرین! تمرین با موفقیت انجام شد';
  static const String workoutLogged = 'تمرین %s ثبت شد';
  static const String exitWorkoutTitle = 'خروج از تمرین';
  static const String exitWorkoutConfirm = 'آیا مطمئن هستید؟ پیشرفت تمرین ذخیره نمی‌شود.';
  static const String showDescription = 'نحوه اجرا';
  static const String hideDescription = 'بستن توضیحات';
  static const String pause = 'توقف';
  static const String start = 'شروع';
  static const String finishSet = 'پایان ست';
  static const String skipExercise = 'رد کردن تمرین';
  static const String skip = 'رد کردن';
  static const String nextExerciseLabel = 'تمرین بعدی';
  static const String timed = 'زمانی';
  static const String repBased = 'تکراری';
  static const String weight = 'وزنه';
  static const String weightUnit = 'ک‌گ';
  static const String tensionLevel = 'سطح سختی';
  static const String tensionHint = '۱ تا ۵';
  static const String tensionUnit = 'سطح';
  static const String addedWeight = 'وزن اضافه';
  static const String optional = 'اختیاری';
  static const String reps = 'تکرار';
  static const String weightHint = 'وزنه (ک‌گ)';
  static const String repsHint = 'تکرار';

  // ===================== Add Exercise =====================
  static const String addExercise = 'افزودن تمرین';
  static const String exerciseDescription = 'توضیحات تمرین';
  static const String exerciseDescriptionHint = 'توضیحات کامل و نحوه اجرای حرکت';
  static const String coachCues = 'راهنمای مربی';
  static const String coachCuesHint = 'نکات کلیدی برای اجرای صحیح حرکت';
  static const String equipment = 'تجهیزات';
  static const String workoutDay = 'روز تمرینی';
  static const String numberOfSets = 'تعداد ست‌ها';
  static const String timedSubtitle = 'مدت زمان هر ست بر حسب ثانیه';
  static const String repsSubtitle = 'تعداد تکرار در هر ست';
  static const String timePerSet = 'زمان هر ست (ثانیه)';
  static const String repsCount = 'تعداد تکرار';
  static const String restTimeSeconds = 'زمان استراحت (ثانیه)';
  static const String saveExercise = 'ثبت تمرین';
  static const String changeFile = 'تغییر فایل';
  static const String selectFile = 'انتخاب فایل';
  static const String supportedMediaFormats = 'پشتیبانی از: JPG, PNG, GIF, MP4, MOV, JSON (Lottie)';
  static const String noPlan = 'برنامه‌ای وجود ندارد';
  static const String noActiveDays = 'هیچ روز فعالی وجود ندارد';
  static const String enterValidNumber = 'عدد معتبر وارد کنید';
  static const String enterPositiveNumber = 'عدد مثبت وارد کنید';
  static const String restTimeRangeError = 'زمان استراحت باید بین ۵ تا ۳۰۰ ثانیه باشد';
  static const String fieldRequired = '%s را وارد کنید';
  static const String fieldLabel = 'این فیلد';

  // ===================== Plan Editor =====================
  static const String addDay = 'افزودن روز';
  static const String workoutDays = 'روزهای تمرین';
  static const String days = 'روزها';
  static const String exercises = 'تمرین‌ها';
  static const String renamePlan = 'تغییر نام برنامه';
  static const String addNewDay = 'افزودن روز جدید';
  static const String deleteDay = 'حذف روز';
  static const String confirmDeleteDay = 'آیا مطمئن هستید که "%s" حذف شود؟';
  static const String dayDetails = 'جزئیات روز';
  static const String noExercisesAdded = 'هنوز تمرینی اضافه نشده';
  static const String exerciseNameRequired = 'نام تمرین الزامی است';
  static const String validNumber = 'عدد معتبر';
  static const String noEquipment = 'بدون تجهیزات';
  static const String daySummary = '%d تمرین - %d ست - %d دقیقه';

  // ===================== Create Plan =====================
  static const String planNameRequired = 'نام برنامه را وارد کنید';
  static const String createPlan = 'ایجاد برنامه';

  // ===================== Workout History =====================
  static const String workoutHistory = 'تاریخچه تمرینات';
  static const String noWorkoutLogged = 'هنوز تمرینی ثبت نشده';
  static const String historyEmptyHint = 'پس از اتمام اولین تمرین، تاریخچه‌ات اینجا نمایش داده می‌شود.';
  static const String startFirstWorkout = 'شروع اولین تمرین';

  // ===================== Profile =====================
  static const String profileTitle = 'پروفایل';
  static const String backgroundMusic = 'موزیک پس‌زمینه تمرین';
  static const String changeMusic = 'تغییر موزیک';
  static const String selectMusic = 'انتخاب موزیک';
  static const String supportedAudioFormats = 'پشتیبانی از: MP3, AAC, WAV, OGG, M4A';

  // ===================== TTS Toggle =====================
  static const String ttsEnabled = 'دستیار صوتی فعال شد';
  static const String ttsDisabled = 'دستیار صوتی غیرفعال شد';
  static const String soundEnabled = 'صدا فعال';
  static const String soundDisabled = 'صدا غیرفعال';

  // ===================== Analytics =====================
  static const String exerciseAnalytics = 'تحلیل تمرین';
  static const String volume = 'حجم تمرین';
  static const String estimated1RM = 'تخمین ۱ تکرار بیشینه';
  static const String progressTrend = 'روند پیشرفت';
  static const String weightProgress = 'روند وزنه';
  static const String volumeProgress = 'روند حجم تمرین';
  static const String personalRecord = 'رکورد شخصی';
  static const String newRecord = 'رکورد جدید ثبت شد!';
  static const String prBadge = 'رکورد';
  static const String noDataForChart = 'داده‌ای برای نمایش وجود ندارد';
  static const String maxWeight = 'بیشترین وزنه';
  static const String bestEstimated1RM = 'بهترین تخمین ۱RM';
  static const String kg = 'ک‌گ';
  static const String date = 'تاریخ';
  static const String lastWeek = 'هفته گذشته';
  static const String lastMonth = 'ماه گذشته';
  static const String allTime = 'همه زمان‌ها';

  // ===================== Body Weight =====================
  static const String bodyWeight = 'وزن بدن';
  static const String bodyWeightTracking = 'ثبت وزن بدن';
  static const String weightTrend = 'نمودار تغییرات وزن';
  static const String addWeight = 'ثبت وزن جدید';
  static const String weightLabel = 'وزن (کیلوگرم)';
  static const String weightInputHint = 'مثلاً ۷۵.۵';
  static const String weightNoteHint = 'یادداشت (اختیاری)';
  static const String weightLogSaved = 'وزن ثبت شد';
  static const String weightLogEmpty = 'هنوز وزنی ثبت نشده';
  static const String weightLogDeleteConfirm = 'این رکورد وزن حذف شود؟';
  static const String today = 'امروز';
  static const String noRecordToday = 'امروز ثبت نشده';
  static const String quickAdd = 'ثبت سریع';

  // ===================== Consistency Calendar =====================
  static const String consistencyCalendar = 'تقویم استمرار';
  static const String noWorkoutDays = 'هنوز تمرینی ثبت نشده';
  static const String daysActive = 'روز فعال';
  static const String currentStreak = 'روز متوالی';
  static const String setsOnDay = 'ست';

  // ===================== Weekly Insights =====================
  static const String weeklySummary = 'خلاصه هفته';
  static const String weeklyFrequency = 'تعداد تمرین در هفته';
  static const String weeklyVolumeChange = 'تغییر حجم نسبت به هفته قبل';
  static const String volumeUp = 'افزایش';
  static const String volumeDown = 'کاهش';
  static const String volumeSame = 'بدون تغییر';
  static const String workoutsInWeek = 'تمرین در این هفته';
  static const String percentSymbol = '٪';

  // ===================== Validation =====================
  static const String setsCountError = 'تعداد ست نباید بیشتر از ۲۰ باشد';
}
