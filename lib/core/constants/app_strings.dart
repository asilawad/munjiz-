/// Every user-facing text of Munjiz (Arabic, RTL by default).
abstract final class AppStrings {
  // Brand
  static const String appName = 'مُنجِز';
  static const String appNameEn = 'Munjiz';

  // Home
  static const String searchHint = 'ابحث عن مهمة...';
  static const String todayProgressTitle = 'مهام اليوم';
  static const String noTasksToday = 'لا توجد مهام لليوم';
  static String progressOf(int done, int total) => '$done من $total';

  // Filters
  static const String filterAll = 'الكل';
  static const String filterToday = 'اليوم';
  static const String filterRoutine = 'الروتين';
  static const String filterPinned = 'المثبّتة';

  // Sections
  static const String sectionPinned = 'المثبّتة';
  static const String sectionOverdue = 'المتأخرة';
  static const String sectionToday = 'مهام اليوم';
  static const String sectionUpcoming = 'القادمة';
  static const String sectionNoDate = 'بدون تاريخ';
  static const String sectionDay = 'مهام اليوم المحدد';
  static const String sectionCompleted = 'المنجزة';

  // Categories
  static const String categoryImportant = 'مهم';
  static const String categoryPersonal = 'شخصي';
  static const String categoryWork = 'عمل';
  static const String categoryIdeas = 'أفكار';
  static const String categoryOther = 'أخرى';

  // Task form
  static const String addTaskTitle = 'إضافة مهمة';
  static const String editTaskTitle = 'تعديل المهمة';
  static const String fieldTitle = 'عنوان المهمة';
  static const String titleHint = 'مثال: قراءة كتاب';
  static const String fieldDescription = 'وصف (اختياري)';
  static const String descriptionHint = 'أضف تفاصيل إضافية...';
  static const String fieldCategory = 'الفئة';
  static const String customCategoryHint = 'اكتب اسم الفئة';
  static const String fieldDueDate = 'تاريخ الاستحقاق';
  static const String noDate = 'بدون تاريخ';
  static const String routine = 'روتين';
  static const String daily = 'يومي';
  static const String specificDays = 'أيام محددة';
  static const String save = 'حفظ';
  static const String cancel = 'إلغاء';
  static const String fieldRequired = 'هذا الحقل مطلوب';

  // Task details
  static const String detailsTitle = 'تفاصيل المهمة';
  static const String rowDate = 'التاريخ';
  static const String rowRepeat = 'التكرار';
  static const String rowStatus = 'الحالة';
  static const String rowPin = 'التثبيت';
  static const String pinned = 'مثبّتة';
  static const String notPinned = 'غير مثبّتة';
  static const String statusDone = 'منجزة';
  static const String statusPending = 'قيد الإنجاز';
  static const String statusDoneToday = 'منجزة اليوم';
  static const String statusPendingToday = 'لم تُنجز اليوم';
  static const String pin = 'تثبيت';
  static const String unpin = 'إلغاء التثبيت';
  static const String edit = 'تعديل';
  static const String delete = 'حذف';
  static const String repeatSeparator = '، ';

  // Dialogs
  static const String deleteTitle = 'حذف المهمة';
  static const String deleteMessage =
      'هل أنت متأكد من حذف هذه المهمة؟ لا يمكن التراجع عن هذا الإجراء.';
  static String pinLimitTitle(int max) => 'يمكنك تثبيت $max مهام فقط';
  static const String pinLimitMessage =
      'لقد وصلت للحد الأقصى من المهام المثبّتة. ألغِ تثبيت مهمة أولًا.';
  static const String ok = 'حسنًا';
  static const String celebrationTitle = 'أحسنت! أنجزت كل مهام اليوم';
  static const String celebrationMessage = 'يوم رائع، استمر على هذا الإنجاز!';
  static const String celebrationAction = 'رائع';

  // Snackbars
  static const String taskCompleted = 'تم إنجاز المهمة';
  static const String taskCompletedEn = 'Task completed!';
  static const String undo = 'تراجع';
  static const String taskAdded = 'تمت إضافة المهمة';
  static const String taskUpdated = 'تم تحديث المهمة';
  static const String taskDeleted = 'تم حذف المهمة';

  // States
  static const String emptyTitle = 'لا توجد مهام';
  static const String emptyMessage =
      'ابدأ بإضافة مهمتك الأولى وحقق المزيد من الإنجاز.';
  static const String addTask = 'إضافة مهمة';
  static const String noResultsTitle = 'لا توجد نتائج';
  static const String noResultsMessage = 'جرّب تغيير البحث أو الفلاتر.';
  static const String loading = 'جارٍ التحميل...';
  static const String loadingHint = 'يرجى الانتظار';
  static const String errorTitle = 'حدث خطأ';
  static const String loadError = 'تعذّر تحميل المهام.';
  static const String retry = 'إعادة المحاولة';
  static const String taskNotFound = 'المهمة غير موجودة';

  // Notifications
  static const String notificationChannelName = 'تذكيرات مُنجِز';
  static const String notificationChannelDescription =
      'اقتباسات تحفيزية وعدد المهام المتبقية';
  static const String notifMorningTitle = 'صباح الإنجاز';
  static const String notifEveningTitle = 'تذكير المساء';
  static const String notifAllDone = 'لا توجد مهام متبقية لليوم، أحسنت!';
  static const String notifLineSeparator = '\n';
  static String notifRemaining(int n) {
    if (n == 1) return 'لديك مهمة واحدة متبقية';
    if (n == 2) return 'لديك مهمتان متبقيتان';
    if (n <= 10) return 'لديك $n مهام متبقية';
    return 'لديك $n مهمة متبقية';
  }

  // Dates
  static const String dateFormat = 'yyyy/MM/dd';

  /// Indexed by `DateTime.weekday - 1` (Monday first).
  static const List<String> weekdayShort = <String>[
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  /// Short 3-letter names for the routine day circles.
  static const List<String> weekdayNarrow = <String>[
    'اثن',
    'ثلا',
    'أرب',
    'خمي',
    'جمع',
    'سبت',
    'أحد',
  ];
}
