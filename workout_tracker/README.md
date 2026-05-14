# 🏋️ ردیاب تمرین (Workout Tracker)

یک اپلیکیشن فول-فیچر مدیریت و پیگیری تمرینات بدنسازی با **فلاتر**، کاملاً فارسی و RTL.

## ✨ ویژگی‌ها

- **برنامه‌های تمرینی**: بساز، ویرایش کن، مرتب کن
- **روزهای تمرین**: هر برنامه شامل روزهای مختلف با تمرینات متنوع
- **انواع تمرین**: ست و تکرار / تایمر (شمارش معکوس)
- **تایمر استراحت**: شمارش معکوس خودکار بین ست‌ها با نوتیفیکیشن
- **پیش‌نمایش مدیا**: تصاویر و ویدیوهای آموزشی برای هر تمرین
- **پیشرفت实时**: نوار پیشرفت و آمار لحظه‌ای
- **ذخیره خودکار**: پیشرفت تمرینات بعد از هر ست ذخیره می‌شود
- **تاریخچه**: مشاهده برنامه‌ها و روزهای تمرینی گذشته
- **حالت شب/روز**: قابلیت تغییر تم (روشن، تیره، همراه با سیستم)
- **یادآور روزانه**: نوتیفیکیشن یادآوری تمرین (اختیاری)
- **صفحه خوش‌آمدگویی**: راهنمای اولیه در اولین اجرا
- **انیمیشن‌های نرم**: Fade, Scale, Slide برای تجربه کاربری بهتر
- **مدیریت حالت**: `error`, `loading`, `empty` برای همه صفحه‌ها
- **مرتب‌سازی**: `ReorderableListView` برای روزها و تمرینات

## 📱 پیش‌نمایش

| صفحه | توضیح |
|------|-------|
| **خوش‌آمدگویی** | ۳ صفحه معرفی در اولین اجرا |
| **خانه** | برنامه فعال، پیشرفت کلی، تمرین امروز |
| **برنامه‌ها** | لیست همه برنامه‌ها با جزئیات |
| **جزئیات برنامه** | روزها و تمرینات هر برنامه + دکمه ویرایش |
| **ساخت/ویرایش برنامه** | فرم کامل با قابلیت اضافه کردن روز و تمرین |
| **تمرین** | کارت تمرینات، شروع ست، تایمر، استراحت |
| **اتمام روز** | بعد از کامل شدن همه تمرینات |
| **تاریخچه** | لیست برنامه‌ها با جزئیات روزها |
| **پروفایل** | تنظیمات تم، یادآور، نسخه |

## 🚀 نحوه نصب و اجرا

### پیش‌نیازها

- Flutter SDK >= 3.11.5
- Dart SDK >= 3.11.5
- Android Studio / Xcode (برای build)

### مراحل اجرا

```bash
# 1. ورود به پروژه
cd workout_tracker

# 2. نصب وابستگی‌ها
flutter pub get

# 3. اجرا روی دستگاه / شبیه‌ساز
flutter run

# 4. اجرا با انتشار (release mode)
flutter run --release
```

### ساخت APK

```bash
# APK عادی
flutter build apk

# APK بهینه‌شده (تقسیم بر معماری)
flutter build apk --split-per-abi

# APK با شکسته‌بندی
flutter build apk --obfuscate --split-debug-info=build/debug-info

# مکان فایل خروجی
# build/app/outputs/flutter-apk/app-release.apk
```

### ساخت App Bundle (توصیه شده برای انتشار در Google Play)

```bash
flutter build appbundle
# خروجی: build/app/outputs/bundle/release/app-release.aab
```

### ساخت برای iOS (فقط در macOS)

```bash
flutter build ios
# یا برای انتشار
flutter build ipa
```

## 📖 نحوه استفاده از برنامه

### ۱. اولین اجرا
در اولین اجرا، صفحه خوش‌آمدگویی نمایش داده می‌شود. پس از رد کردن، وارد صفحه اصلی می‌شوید.

### ۲. ساخت برنامه جدید
1. به تب **برنامه‌ها** بروید
2. دکمه **برنامه جدید** را بزنید
3. نام برنامه را وارد کنید
4. با دکمه **اضافه کردن روز** روزهای تمرینی را اضافه کنید
5. برای هر روز، با دکمه **اضافه کردن تمرین** تمرینات را وارد کنید:
   - **نام تمرین**: مثلاً "پرس سینه هالتر"
   - **نوع**: ست و تکرار / تایمر
   - **ست و تکرار**: تعداد ست + تعداد تکرار
   - **تایمر**: مدت زمان (دقیقه:ثانیه)
   - **زمان استراحت**: بین ست‌ها (دقیقه:ثانیه)
   - **تجهیزات**: هالتر، دمبل، ...
   - **تصویر**: آدرس URL عکس تمرین
   - **ویدیو**: آدرس URL ویدیو آموزشی
6. با دکمه **ساخت برنامه** ذخیره کنید

### ۳. شروع تمرین
1. از صفحه **خانه** یا **جزئیات برنامه**، دکمه **شروع** را بزنید
2. در صفحه تمرین:
   - دکمه **شروع ست** را بزنید
   - تمرین را انجام دهید و **ست تمام شد** را بزنید
   - در زمان استراحت تایمر شمارش معکوس نشان داده می‌شود
   - برای تمرینات تایمری، زمان به صورت خودکار شمارش می‌شود
3. بعد از اتمام همه ست‌ها، دکمه **برگشت به تمرینات** را بزنید
4. بعد از اتمام همه تمرینات، دکمه سبز **اتمام روز** فعال می‌شود

### ۴. ویرایش برنامه
- از صفحه **جزئیات برنامه**، دکمه ویرایش (مداد) را بزنید
- روزها و تمرینات را با drag handle جابجا کنید
- تمرین جدید اضافه کنید یا تمرینات موجود را ویرایش/حذف کنید

### ۵. تنظیمات
در صفحه **پروفایل** می‌توانید:
- تم روشن/تیره/همراه با سیستم را انتخاب کنید
- یادآور روزانه را فعال/غیرفعال کنید

## 📂 ساختار پروژه

```
workout_tracker/
├── lib/
│   ├── main.dart                    # نقطه ورود، تنظیمات Hive و Riverpod
│   ├── core/                        # هسته برنامه
│   │   ├── app_providers.dart       # Providerهای سراسری (تم، خوش‌آمدگویی، نوتیفیکیشن)
│   │   ├── constants.dart           # ثابت‌های برنامه
│   │   ├── extensions.dart          # اکستنشن‌های BuildContext و DateTime
│   │   ├── routes.dart              # تنظیمات مسیریابی GoRouter
│   │   ├── theme.dart               # تم روشن و تیره Material 3
│   │   └── utils.dart               # توابع کمکی
│   ├── data/                        # لایه داده
│   │   ├── adapters/                # Hive TypeAdapterها
│   │   │   └── hive_adapters.dart
│   │   ├── models/                  # مدل‌های داده
│   │   │   ├── daily_log.dart       # لاگ روزانه تمرین
│   │   │   ├── exercise.dart        # مدل تمرین
│   │   │   ├── exercise_history.dart # تاریخچه تمرین
│   │   │   ├── exercise_type.dart   # enum نوع تمرین
│   │   │   ├── workout_day.dart     # مدل روز تمرین
│   │   │   ├── workout_program.dart # مدل برنامه تمرین
│   │   │   └── workout_progress.dart# مدل پیشرفت
│   │   ├── providers/               # Riverpod Providerها
│   │   │   └── workout_providers.dart
│   │   └── repositories/           # مخزن داده (Hive CRUD)
│   │       └── workout_repository.dart
│   ├── features/                    # صفحه‌ها (Screens)
│   │   ├── create_program_screen.dart    # ساخت/ویرایش برنامه
│   │   ├── exercise_detail_screen.dart   # جزئیات تمرین (آماده)
│   │   ├── history_screen.dart           # تاریخچه تمرینات
│   │   ├── home_screen.dart              # صفحه اصلی
│   │   ├── onboarding_screen.dart        # خوش‌آمدگویی
│   │   ├── program_detail_screen.dart     # جزئیات برنامه
│   │   ├── programs_screen.dart          # لیست برنامه‌ها
│   │   ├── profile_screen.dart           # پروفایل و تنظیمات
│   │   ├── shell_screen.dart             # شل با نویگیشن پایین
│   │   └── workout_session_screen.dart   # صفحه تمرین فعال
│   └── widgets/                     # ویجت‌های قابل استفاده مجدد
│       ├── animations.dart          # انیمیشن‌های Fade/Scale
│       ├── day_progress_header.dart # هeder پیشرفت روز
│       ├── exercise_card.dart       # کارت تمرین
│       ├── exercise_media_preview.dart # پیش‌نمایش مدیا
│       ├── rest_timer_bottom_sheet.dart # تایمر استراحت
│       ├── set_timer_widget.dart    # ویجت تایمر ست
│       └── workout_card.dart        # کارت برنامه
├── assets/
│   └── animations/                  # فایل‌های Lottie (اختیاری)
├── test/
│   └── widget_test.dart
└── pubspec.yaml
```

## 🧱 معماری

- **State Management**: Riverpod 2.x
- **مسیریابی**: GoRouter با StatefulShellRoute (Bottom Navigation)
- **ذخیره‌سازی محلی**: Hive + SharedPreferences
- **محلی‌سازی**: فارسی (fa_IR) با RTL کامل
- **Material 3**: با قابلیت تغییر تم (روشن/تیره/سیستم)
- **UI/UX**: 
  - AnimatedContainer برای transitions نرم
  - CustomTransitionPage برای انیمیشن بین صفحه‌ها
  - SegmentedButton برای انتخاب‌ها
  - ReorderableListView برای مرتب‌سازی

## 🔧 نکات مهم برای توسعه

### اضافه کردن قابلیت جدید
1. مدل جدید را در `data/models/` بسازید
2. HiveAdapter مربوطه را در `hive_adapters.dart` ثبت کنید
3. Provider در `workout_providers.dart` یا `app_providers.dart` اضافه کنید
4. Repository method در `workout_repository.dart` اضافه کنید
5. صفحه در `features/` بسازید و در `routes.dart` ثبت کنید

### افزودن تمرین جدید به برنامه
از صفحه **ساخت برنامه** یا **ویرایش برنامه**:
1. روز مورد نظر را انتخاب کنید
2. دکمه **اضافه کردن تمرین** را بزنید
3. فرم را پر کنید (نام، نوع، ست/تکرار یا تایمر، استراحت، تجهیزات)
4. برای اضافه کردن تصویر/ویدیو، URL معتبر وارد کنید و با دکمه پیش‌نمایش بررسی کنید

### شخصی‌سازی تم
رنگ اصلی در `core/theme.dart` با `colorSchemeSeed` قابل تغییر است:
```dart
static const Color _indigoSeed = Color(0xFF3F51B5); // ← این را تغییر دهید
```

### اضافه کردن فونت فارسی
در `pubspec.yaml`:
```yaml
fonts:
  - family: Vazir
    fonts:
      - asset: assets/fonts/Vazir-Regular.ttf
      - asset: assets/fonts/Vazir-Bold.ttf
        weight: 700
```
سپس در `theme.dart`:
```dart
fontFamily: 'Vazir',
```

## 🐛 خطاهای رایج و رفع آنها

| خطا | راه‌حل |
|-----|--------|
| `HiveError: Adapter not found` | `flutter clean && flutter pub get && flutter run` |
| `Could not build the app for simulator` | `cd ios && pod install && cd ..` |
| `flutter_local_notifications` خطا | حتماً `compileSdkVersion 34` در `android/app/build.gradle` |
| نمایش نادرست RTL | بررسی `Directionality(textDirection: TextDirection.rtl)` |

## 📄 لایسنس

این پروژه برای استفاده شخصی و آموزشی ساخته شده است.
