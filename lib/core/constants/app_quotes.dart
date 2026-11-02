/// Motivational quotes used by the daily notifications (Arabic / English).
abstract final class AppQuotes {
  static const List<String> arabic = <String>[
    'خطوة صغيرة كل يوم تصنع فرقاً كبيراً.',
    'ابدأ الآن، فالإنجاز يبدأ بقرار.',
    'التزامك اليوم هو نجاحك غداً.',
    'لا تؤجّل عمل اليوم، فغداً لك مهام جديدة.',
    'الاستمرار أهم من الكمال.',
    'كل مهمة تنجزها تقرّبك من هدفك.',
  ];

  static const List<String> english = <String>[
    'Small steps every day add up to big results.',
    'Start now. Progress begins with a decision.',
    'Consistency beats intensity.',
    'Done is better than perfect.',
    'Every task you finish moves you closer to your goal.',
    'Your future self will thank you for today.',
  ];

  /// Arabic and English quotes interleaved.
  static List<String> get all => <String>[
    for (int i = 0; i < arabic.length; i++) ...<String>[arabic[i], english[i]],
  ];
}
