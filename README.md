# 🏋️ exo — برنامه تمرینی ۳ روزه

<div align="center">

**اپلیکیشن مدیریت تمرینات ورزشی با طراحی مدرن و معماری حرفه‌ای**

[![Flutter](https://img.shields.io/badge/Flutter-3.11.5-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.5-blue?logo=dart)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.6.1-green?logo=riverpod)](https://riverpod.dev)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-green?logo=android)](https://flutter.dev)

</div>

---

## 📸 پیش‌نمایش

```
┌─────────────────────────────────────────────┐
│                                             │
│         🏋️  برنامه تمرینی ۳ روزه            │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  📅 روز اول              ✅ تکمیل   │   │
│  │  ۴ تمرین · ۱۲ ست                    │   │
│  │  [شروع تمرین]                        │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  📅 روز دوم              🔓 باز     │   │
│  │  ۳ تمرین · ۹ ست                     │   │
│  │  [شروع تمرین]                        │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  📅 روز سوم              🔒 قفل     │   │
│  │  ابتدا روز قبلی را کامل کنید        │   │
│  │  [قفل شده]                           │   │
│  └─────────────────────────────────────┘   │
│                                             │
└─────────────────────────────────────────────┘
```

---

## ✨ ویژگی‌ها

| ویژگی | توضیحات |
|-------|---------|
| 📋 **مدیریت تمرین** | افزودن تمرین با نام، تعداد ست، تکرار/زمان، استراحت و نوع تجهیزات |
| ⏱️ **تایمر هوشمند** | اجرای تمرینات زمانی با شروع/توقف خودکار |
| 💪 **شمارش ست** | پیگیری خودکار ست‌ها با امکان رد کردن |
| 😴 **استراحت خودکار** | تایمر استراحت بین ست‌ها با امکان رد کردن |
| 🔐 **سیستم قفل** | روزهای بعدی قفل می‌شوند تا روز قبل کامل شود |
| 💾 **ذخیره‌سازی محلی** | ذخیره پیشرفت با SharedPreferences |
| 🇮🇷 **پشتیبانی RTL** | رابط کاربری کاملاً فارسی و راست‌به‌چپ |
| 🎨 **Material 3** | طراحی مدرن با تم Material Design 3 |
| 🔒 **امنیت State** | Immutable state با List.unmodifiable |
| 🛡️ **مدیریت خطا** | try-catch کامل با logging |
| ⚡ **Performance** | Selector برای rebuild بهینه |

---

## 📱 دمو

> برای مشاهده عملکرد اپلیکیشن، ویدیوی دمو را اجرا کنید یا اپ را روی گوشی نصب کنید.

### جریان کار اپلیکیشن

```
افزودن تمرین → شروع تمرین → اجرای ست → استراحت → تکمیل روز → باز شدن روز بعد
```

---

## 🚀 نصب و اجرا

### پیش‌نیازها

- Flutter SDK ≥ 3.11.5
- Dart SDK ≥ 3.11.5
- Android Studio / VS Code با Flutter extensions

### مراحل نصب

```bash
# ۱. کلون کردن پروژه
git clone https://github.com/unknownman/exo.git
cd exo

# ۲. نصب وابستگی‌ها
flutter pub get

# ۳. اجرای اپلیکیشن
flutter run
```

### برای iOS

```bash
flutter run -d iPhone
```

### برای Android

```bash
flutter run -d android
```

### ساخت نسخه release

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 🏗️ ساختار پروژه

پروژه با معماری **Clean Architecture** و الگوی **Riverpod 2** ساخته شده است.

```
lib/
├── main.dart                          # Entry point + DI setup
├── app.dart                           # MaterialApp configuration
│
├── core/
│   ├── constants/
│   │   └── app_constants.dart         # تمام ثابت‌های برنامه
│   ├── theme/
│   │   └── app_theme.dart             # Material 3 theme
│   └── router/
│       └── app_router.dart            # Named routes
│
├── data/
│   ├── models/
│   │   ├── exercise.dart               # مدل تمرین (Immutable + Equatable)
│   │   └── workout_day.dart           # مدل روز تمرینی
│   ├── datasources/
│   │   └── local_storage_datasource.dart  # SharedPreferences wrapper
│   └── repositories/
│       └── workout_repository_impl.dart   # پیاده‌سازی Repository
│
├── domain/
│   └── repositories/
│       └── workout_repository.dart    # Interface Repository
│
└── presentation/
    ├── providers/
    │   ├── workout_provider.dart      # StateNotifier: مدیریت روزها
    │   ├── active_workout_provider.dart  # StateNotifier: مدیریت تمرین فعال
    │   └── providers.dart             # Export all providers
    ├── screens/
    │   ├── home_screen.dart           # صفحه اصلی
    │   ├── active_workout_screen.dart    # صفحه تمرین فعال
    │   └── add_exercise_screen.dart   # فرم افزودن تمرین
    └── widgets/
        └── day_card.dart             # کارت روز تمرینی
```

### نمودار معماری

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Screens   │  │  Providers  │  │      Widgets        │ │
│  │   (UI)     │  │ (Riverpod)  │  │    (Reusable)       │ │
│  └──────┬──────┘  └──────┬──────┘  └─────────────────────┘ │
└─────────┼───────────────┼─────────────────────────────────┘
          │               │
          ▼               ▼
┌─────────────────────────────────────────────────────────────┐
│                       Domain Layer                          │
│  ┌─────────────────────────────────────────────────────┐  │
│  │              WorkoutRepository (Abstract)           │  │
│  └─────────────────────────┬───────────────────────────┘  │
└────────────────────────────┼───────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                        Data Layer                            │
│  ┌────────────┐  ┌─────────────┐  ┌────────────────────┐  │
│  │   Models   │  │ DataSources │  │Repository Impl     │  │
│  │  (Entity)  │  │ (Storage)   │  │ (Concrete)         │  │
│  └────────────┘  └─────────────┘  └────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛠️ فناوری‌ها و ابزارها

| فناوری | نسخه | کاربرد |
|--------|------|--------|
| **Flutter** | 3.11.5 | فریمورک اصلی |
| **Dart** | 3.11.5 | زبان برنامه‌نویسی |
| **flutter_riverpod** | 2.6.1 | State Management |
| **riverpod_annotation** | 2.6.1 | Code Generation |
| **shared_preferences** | 2.3.4 | Local Storage |
| **Material 3** | - | طراحی UI |

---

## 🔧 چگونه کار می‌کند؟

### ۱. افزودن تمرین
```
کاربر → فرم افزودن تمرین → Validation → WorkoutProvider.addExercise() → ذخیره
```

### ۲. شروع تمرین
```
کاربر → انتخاب روز → ActiveWorkoutScreen → ActiveWorkoutProvider.startWorkout()
```

### ۳. اجرای تمرین
```
تایمر فعال / شمارش ست → پایان ست → استراحت → تکمیل یا رفتن به بعدی
```

### ۴. تکمیل روز
```
همه تمرینات انجام شد → finishWorkout() → completeDay() → باز شدن روز بعد
```

---

## 📸 اسکرین‌شات‌ها

### صفحه اصلی
```
┌─────────────────────────────────────────────┐
│  برنامه تمرینی ۳ روزه                    ⋮ │
├─────────────────────────────────────────────┤
│                                             │
│  📅 روز اول                     🟢 تکمیل   │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                             │
│  💪 اسکات          ۴ ست × ۱۵ تکرار       │
│  💪 پرس سینه       ۳ ست × ۱۲ تکرار       │
│  💪 ددلیفت        ۴ ست × ۱۰ تکرار       │
│                                             │
│  [    ✅ انجام شد     ]                     │
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│  📅 روز دوم                        🔓 باز   │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                             │
│  ⚠️ هنوز تمرینی اضافه نشده                  │
│                                             │
│  [    ▶ شروع تمرین    ]                     │
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│  📅 روز سوم                        🔒 قفل   │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                             │
│  🔒 ابتدا روز قبلی را کامل کنید             │
│                                             │
│  [    🔒 قفل شده      ]                     │
│                                             │
└─────────────────────────────────────────────┘
                  [+ افزودن]
```

### صفحه تمرین فعال
```
┌─────────────────────────────────────────────┐
│  روز اول                            ✕     │
├─────────────────────────────────────────────┤
│                                             │
│              💪                            │
│                                             │
│         اسکات                               │
│      تجهیزات: وزن بدن                       │
│                                             │
│  ┌───────────┬───────────┐                │
│  │   ست      │  تمرین    │                │
│  │   ۲/۴     │   ۱/۴     │                │
│  └───────────┴───────────┘                │
│                                             │
│                                             │
│              ۱۵                           │
│            تکرار                            │
│                                             │
│  [     ⏹️ پایان ست     ]                    │
│                                             │
│  [ ← رد کردن ]                              │
│                                             │
└─────────────────────────────────────────────┘
```

---

## 📈 بهبودهای انجام‌شده

### از MVP به Production-Ready

| نسخه | امتیاز | تغییرات |
|------|--------|--------|
| **v1.0 (MVP)** | 4.5/10 | Provider ساده، business logic در UI، بدون error handling |
| **v2.0 (Current)** | 8.3/10 | Clean Architecture، Riverpod 2، Immutable State، Null Safety |

### بهبودهای کلیدی

| دسته | قبل | بعد |
|------|------|------|
| **معماری** | MVC مخلوط | Clean Architecture 3 لایه |
| **State Management** | ChangeNotifier | StateNotifier + Selectors |
| **امنیت** | Mutable state | List.unmodifiable + Immutable |
| **خطا** | بدون handling | try-catch + debugPrint |
| **crash prevention** | firstWhere بدون check | indexWhere + null check |
| **performance** | Consumer rebuild همه | Selector granular rebuild |
| **validation** | ساده | کامل با محدوده‌ها |
| **testability** | پایین | بالا با separation of concerns |

---

## 🤝 نحوه مشارکت

از مشارکت شما استقبال می‌کنیم! 🎉

```bash
# ۱. Fork پروژه

# ۲. ایجاد branch جدید
git checkout -b feature/new-feature

# ۳. اعمال تغییرات و commit
git commit -m "Add new feature"

# ۴. Push به branch
git push origin feature/new-feature

# ۵. ایجاد Pull Request
```

---

## 📄 لایسنس

این پروژه تحت لایسنس **MIT** منتشر شده است.

```
MIT License

Copyright (c) 2026 Ali Joder

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 👨‍💻 توسعه‌دهنده

<div align="center">

**علی جودر**  
Senior Flutter Developer

📧 ali.masoudi.alavi@gmail.com  
🌐 [GitHub](https://github.com/unknownman)

</div>

---

<div align="center">

ساخته شده با ❤️ و Flutter

</div>