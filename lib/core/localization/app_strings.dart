import 'package:flutter/material.dart';

import '../config/app_state.dart';

/// Centralized Arabic / English localization strings for the AgriTech app.
/// Ensures consistent RTL (Arabic) and LTR (English) text across Settings,
/// General Settings, Modals (Support, Privacy Policy, Terms of Use, User Guide,
/// Logout), Headers, and Navigation without scattered conditionals.
class AppStrings {
  const AppStrings(this.languageCode);

  final String languageCode;

  bool get isAr => languageCode == 'ar';

  TextDirection get textDirection =>
      isAr ? TextDirection.rtl : TextDirection.ltr;

  static AppStrings of(BuildContext context) {
    final appState = AppStateScope.maybeOf(context);
    if (appState != null) {
      return AppStrings(appState.languageCode);
    }
    final locale = Localizations.maybeLocaleOf(context);
    return AppStrings(locale?.languageCode ?? 'ar');
  }

  // --- Common / Navigation / Header ---
  String get backTooltip => isAr ? 'رجوع' : 'Back';
  String get settingsTooltip => isAr ? 'الإعدادات' : 'Settings';
  String get closeLabel => isAr ? 'إغلاق' : 'Close';
  String get cancelLabel => isAr ? 'إلغاء' : 'Cancel';
  String get understoodLabel => isAr ? 'فهمت' : 'Understood';

  String get navHome => isAr ? 'الرئيسية' : 'Home';
  String get navMonitoring => isAr ? 'المراقبة' : 'Monitoring';
  String get navDiagnosis => isAr ? 'التشخيص' : 'Diagnosis';
  String get navMyFarms => isAr ? 'مزارعي' : 'My Farms';
  String get navMyAccount => isAr ? 'حسابي' : 'My Account';

  // --- Settings & General Settings Screens (Screens 14 & 15) ---
  String get settingsTitle => isAr ? 'الإعدادات' : 'Settings';
  String get settingsSubtitle => isAr
      ? 'خصص التطبيق حسب تفضيلاتك وتفضيلات مزرعتك'
      : 'Customize the application according to your farm preferences';

  String get generalSettingsTitle =>
      isAr ? 'الإعدادات العامة' : 'General Settings';
  String get generalSettingsSubtitle => isAr
      ? 'تخصيص اللغة ومظهر التطبيق'
      : 'Customize application language and appearance';

  String get appPreferencesSection =>
      isAr ? 'تفضيلات التطبيق' : 'Application Preferences';

  String get languageTitle => isAr ? 'اللغة' : 'Language';
  String get languageSubtitle => isAr
      ? 'لغة عرض القوائم والتقارير الزراعية'
      : 'Display language for menus and agricultural reports';
  String get arabicLabel => 'العربية';
  String get arabicBadge => isAr ? 'الافتراضية' : 'Default';
  String get englishLabel => 'English';
  String get englishBadge => isAr ? 'الإنجليزية' : 'Active';

  String get appearanceTitle => isAr ? 'المظهر' : 'Appearance';
  String get appearanceSubtitle => isAr
      ? 'اختر نمط الإضاءة المناسب لظروف الحقل'
      : 'Choose the display mode suitable for field conditions';
  String get themeLight => isAr ? 'فاتح' : 'Light';
  String get themeDark => isAr ? 'داكن' : 'Dark';
  String get themeSystem => isAr ? 'تلقائي' : 'System';

  String get notificationsSectionTitle => isAr ? 'الإشعارات' : 'Notifications';
  String get agriAlertsTitle =>
      isAr ? 'التنبيهات الزراعية' : 'Agricultural Alerts';
  String get agriAlertsDescription => isAr
      ? 'تلقي إشعارات التوصيات الذكية وفترات الري والتنبيهات المناخية العاجلة.'
      : 'Receive smart recommendation alerts, irrigation schedules, and urgent climate warnings.';

  String get syncAndConnectionTitle =>
      isAr ? 'الاتصال والمزامنة' : 'Connection & Sync';
  String get refreshAction => isAr ? 'تحديث' : 'Refresh';
  String get connectionStatusLabel =>
      isAr ? 'حالة الاتصال' : 'Connection Status';
  String get connectedToServer => isAr ? 'متصل بالخادم' : 'Connected to Server';
  String get lastFieldSyncLabel =>
      isAr ? 'آخر مزامنة ميدانية' : 'Last Field Sync';
  String syncTimeDisplay(String rawAr) {
    if (isAr) return rawAr;
    if (rawAr.contains('الآن')) return 'Just now (Updated)';
    return 'Today, 10:30 AM';
  }

  String get syncSuccessToast => isAr
      ? 'تمت مزامنة البيانات الميدانية بنجاح'
      : 'Field data synchronized successfully';

  String get helpAndSupportTitle => isAr ? 'المساعدة والدعم' : 'Help & Support';
  String get userGuideTitle => isAr ? 'دليل المستخدم' : 'User Guide';
  String get userGuideSubtitle => isAr
      ? 'تعرف على كيفية استخدام التطبيق والحساسات'
      : 'Learn how to use the app and agricultural sensors';

  String get supportTeamTitle =>
      isAr ? 'فريق الدعم والخصوصية' : 'Support & Privacy Team';
  String get supportTeamSubtitle => isAr
      ? 'أرسل مشكلة أو استفسارًا متعلقًا بالتطبيق'
      : 'Submit an issue or inquiry related to the application';

  String get aboutAppTitle => isAr ? 'حول التطبيق' : 'About the Application';
  String get appTagline =>
      isAr ? 'الزراعة الذكية والمستدامة' : 'Smart & Sustainable Agriculture';
  String get appVersionBadge => isAr ? 'v1.0.0 (تجريبي)' : 'v1.0.0 (Beta)';
  String get aboutAppDescription => isAr
      ? 'نظام زراعي ذكي متكامل مصمم لدعم المزارعين والمهندسين في إدارة المحاصيل، مراقبة الرطوبة، وتشخيص الآفات بدقة عالية.'
      : 'An integrated smart agricultural system designed to support farmers and engineers in crop management, moisture monitoring, and accurate pest diagnosis.';

  String get privacyPolicyTitle => isAr ? 'سياسة الخصوصية' : 'Privacy Policy';
  String get termsOfUseTitle => isAr ? 'شروط الاستخدام' : 'Terms of Use';
  String get appFooterText => isAr
      ? 'تطبيق AgriTech للزراعة الذكية'
      : 'AgriTech Smart Agriculture Application';

  // --- Logout Modal ---
  String get logoutTitle => isAr ? 'تسجيل الخروج' : 'Sign Out';
  String get logoutConfirmQuestion => isAr
      ? 'هل أنت متأكد من رغبتك في تسجيل الخروج من تطبيق AgriTech؟'
      : 'Are you sure you want to sign out of the AgriTech application?';
  String get logoutConfirmButton => isAr ? 'تأكيد الخروج' : 'Confirm Sign Out';

  // --- Support & Privacy Team Modal ---
  String get supportIntroText => isAr
      ? 'واجهت مشكلة أو لديك استفسار؟ اكتب التفاصيل وسنتمكن من مراجعتها.'
      : 'Facing an issue or have an inquiry? Enter the details and our team will review it.';
  String get supportRequestTypeLabel => isAr ? 'نوع الطلب' : 'Request Type';
  String get supportRequestTypePlaceholder =>
      isAr ? '[اختر نوع الطلب]' : '[Select Request Type]';

  List<(String, String)> get supportRequestTypeOptions => isAr
      ? const [
          ('technical', 'مشكلة تقنية'),
          ('sensors', 'مشكلة في الحساسات والقراءات'),
          ('recommendations', 'مشكلة في التوصيات الزراعية'),
          ('privacy', 'استفسار عن الخصوصية والبيانات'),
          ('other', 'اقتراح أو طلب آخر'),
        ]
      : const [
          ('technical', 'Technical Issue'),
          ('sensors', 'Sensor and Readings Issue'),
          ('recommendations', 'Agricultural Recommendations Issue'),
          ('privacy', 'Privacy and Data Inquiry'),
          ('other', 'Suggestion or Other Request'),
        ];

  String get supportTitleLabel => isAr ? 'عنوان المشكلة' : 'Request Title';
  String get supportTitleHint => isAr
      ? 'اكتب عنوانًا مختصرًا للمشكلة'
      : 'Enter a brief title for the issue';
  String get supportDetailsLabel =>
      isAr ? 'تفاصيل المشكلة' : 'Detailed Description';
  String get supportDetailsHint => isAr
      ? 'اشرح المشكلة أو الاستفسار بالتفصيل...'
      : 'Describe the issue or inquiry in detail...';
  String get supportContactMethodLabel =>
      isAr ? 'طريقة التواصل المفضلة' : 'Preferred Contact Method';
  String get supportContactEmail =>
      isAr ? 'البريد الإلكتروني المسجل' : 'Registered Email Address';
  String get supportContactPhone =>
      isAr ? 'رقم الهاتف المسجل' : 'Registered Phone Number';

  String get supportPrivacyPrefix => isAr
      ? 'تُستخدم تفاصيل الطلب لمعالجة الاستفسار وفق '
      : 'Request details are used to process your inquiry according to the approved ';
  String get supportPrivacySuffix => isAr ? ' المعتمدة.' : '.';
  String get supportSubmitButton =>
      isAr ? 'إرسال إلى فريق الدعم' : 'Submit to Support Team';

  String get supportValidationAllRequired => isAr
      ? 'يرجى اختيار نوع الطلب وكتابة العنوان وتفاصيل المشكلة.'
      : 'Please select a request type and enter the title and detailed description.';
  String get supportValidationTypeRequired =>
      isAr ? 'يرجى اختيار نوع الطلب' : 'Please select a request type';
  String get supportValidationTitleRequired =>
      isAr ? 'يرجى إدخال عنوان الطلب' : 'Please enter a request title';
  String get supportValidationDetailsRequired => isAr
      ? 'يرجى كتابة تفاصيل المشكلة أو الاستفسار'
      : 'Please enter the detailed description';
  String get supportValidationContactInvalid => isAr
      ? 'يرجى التحقق من صحة وسيلة التواصل المحددة في حسابك'
      : 'Please verify that the selected contact method is valid in your account';

  String get supportLocalConfirmationBanner => isAr
      ? 'تم التحقق من صحة البيانات وحفظ طلب الدعم محلياً (وضع تجريبي مؤقت — لم يتم الإرسال لخادم خارجي حتى ربط واجهة البرمجة API).'
      : 'Support request validated and saved locally (temporary mock action — not sent to an external server until backend API integration).';

  // --- Privacy Policy Modal Sections ---
  List<(String, String)> get privacySections => isAr
      ? const [
          (
            'البيانات التي يستخدمها التطبيق',
            'قد يتعامل AgriTech مع بيانات الحساب والمزرعة وموقعها وقراءات الحساسات وصور النباتات، بحسب الميزات المستخدمة.',
          ),
          (
            'استخدام البيانات',
            'تُستخدم البيانات لدعم إدارة المزارع ومتابعة القراءات وعرض التوصيات الزراعية وتشخيص صور النباتات عند توفر الميزة.',
          ),
          (
            'التخزين والمزامنة',
            'قد تُحفظ بعض البيانات محليًا وتتم مزامنتها عند توفر الإنترنت، وفقًا للميزات المنفذة.',
          ),
          (
            'الخصوصية وحقوق المستخدم',
            'يمكن للمستخدم مراجعة بياناته وتصحيحها وطلب حذفها وفق الإجراءات التي يدعمها التطبيق.',
          ),
        ]
      : const [
          (
            'Data Used by the Application',
            'AgriTech may process account details, farm information and location, sensor readings, and plant images depending on the features used.',
          ),
          (
            'Use of Data',
            'Data is used to support farm management, monitor sensor readings, display agricultural recommendations, and diagnose plant images when available.',
          ),
          (
            'Storage and Synchronization',
            'Some data may be stored locally on the device and synchronized when an internet connection is available, according to implemented features.',
          ),
          (
            'Privacy and User Rights',
            'Users can review, update, and request deletion of their personal data in accordance with the procedures supported by the application.',
          ),
        ];

  // --- Terms of Use Modal Sections ---
  List<(String, String)> get termsSections => isAr
      ? const [
          (
            'استخدام التطبيق',
            'يساعد AgriTech على إدارة المزارع ومتابعة قراءات الحساسات وعرض التوصيات الزراعية وتشخيص صور النباتات عند توفر الميزات اللازمة.',
          ),
          (
            'متطلبات التشغيل',
            'تتطلب مراقبة القراءات حساسات متوافقة ومهيأة بصورة صحيحة، مثل DHT22 وYL-69 مع وحدة ESP32 DevKit. وقد تحتاج بعض الوظائف إلى اتصال بالإنترنت.',
          ),
          (
            'التوصيات والتشخيص',
            'تعتمد النتائج على البيانات المتاحة والقواعد الزراعية والنموذج المستخدم، وهي أدوات مساعدة لا تضمن تشخيصًا أو نتيجة زراعية مؤكدة.',
          ),
          (
            'مسؤولية المستخدم',
            'يتحمل المستخدم مسؤولية دقة البيانات المدخلة والتحقق من ظروف المزرعة قبل اتخاذ القرارات الزراعية.',
          ),
        ]
      : const [
          (
            'Application Usage',
            'AgriTech assists in managing farms, monitoring sensor readings, displaying agricultural recommendations, and diagnosing plant images when the required features are available.',
          ),
          (
            'Operating Requirements',
            'Monitoring readings requires compatible and properly configured sensors such as DHT22 and YL-69 with an ESP32 DevKit unit. Some features may require an internet connection.',
          ),
          (
            'Recommendations and Diagnosis',
            'Results depend on available data, agricultural rules, and the model used; they serve as decision-support tools and do not guarantee a definitive diagnosis or agricultural outcome.',
          ),
          (
            'User Responsibility',
            'The user is responsible for the accuracy of entered data and for verifying actual field conditions before making agricultural decisions.',
          ),
        ];

  // --- User Guide Modal Sections ---
  List<(String, String)> get userGuideSections => isAr
      ? const [
          (
            '1. البدء باستخدام التطبيق',
            'أنشئ حسابك وسجّل الدخول، ثم أضف بيانات مزرعتك وموقعها والمساحة المزروعة بالبن. استخدم الشاشة الرئيسية لمتابعة ملخص الحالة الزراعية، وانتقل إلى المراقبة للاطلاع على القراءات والتوصيات.',
          ),
          (
            '2. تركيب الحساسات وإعدادها',
            'يتولى المسؤول التقني أو فني مؤهل تركيب الحساسات وتوصيلها بوحدة ESP32 وإعدادها وربطها بالنظام واختبار وصول القراءات. لا يحتاج المزارع إلى تنفيذ التوصيلات الإلكترونية بنفسه.',
          ),
          (
            '3. الحساسات المستخدمة',
            '• DHT22: لقياس درجة حرارة الهواء والرطوبة النسبية.\n'
                '• YL-69: لتقدير رطوبة التربة.\n'
                '• ESP32 DevKit: وحدة تحكم تستقبل بيانات الحساسات وتتيح إرسالها إلى النظام وفق طريقة الاتصال المعتمدة.',
          ),
          (
            '4. متابعة القراءات',
            'اختر المزرعة المطلوبة من شاشة المراقبة، ثم اختر الحساس للاطلاع على القراءة الحالية والقراءات السابقة ومخطط تغيرها عند توفر البيانات.',
          ),
          (
            '5. عند غياب القراءات',
            'تحقق من حالة اتصال الحساس ووقت آخر قراءة. إذا استمرت المشكلة، تواصل مع المسؤول التقني لفحص الحساس وإعداد الاتصال. لا تعتبر القراءة القديمة قراءة لحظية.',
          ),
          (
            '6. التشخيص والتوصيات',
            'يمكنك إرسال صورة واضحة للنبات للتشخيص عند توفر الميزة. تعتمد التوصيات الزراعية على القراءات المتاحة والقواعد المعتمدة، وتُستخدم لمساعدة المزارع في اتخاذ القرار.',
          ),
        ]
      : const [
          (
            '1. Getting Started',
            'Create your account and sign in, then add your farm details, location, and coffee cultivation area. Use the Home screen to follow the agricultural summary and navigate to Monitoring for readings and recommendations.',
          ),
          (
            '2. Sensor Installation and Setup',
            'A technical administrator or qualified technician installs the sensors, connects them to the ESP32 unit, configures network linking, and tests data transmission. Farmers do not need to wire electronics themselves.',
          ),
          (
            '3. Supported Sensors',
            '• DHT22: Measures ambient air temperature and relative humidity.\n'
                '• YL-69: Estimates soil moisture levels.\n'
                '• ESP32 DevKit: Microcontroller unit that collects sensor data and transmits it to the system.',
          ),
          (
            '4. Monitoring Readings',
            'Select the target farm on the Monitoring screen, then choose a sensor to inspect its current reading, historical readings log, and trend chart.',
          ),
          (
            '5. When Readings Are Missing',
            'Check the sensor connection status and last reading timestamp. If the issue persists, contact technical support to inspect the sensor and connection.',
          ),
          (
            '6. Diagnosis and Recommendations',
            'Capture or select a clear coffee leaf photo for diagnosis when available. Agricultural recommendations are generated from sensor thresholds and approved rules to assist field decisions.',
          ),
        ];
}
