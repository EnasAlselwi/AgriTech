import 'package:flutter/material.dart';

import '../../models/agritech_models.dart';

/// Application UI state controller with clearly identified temporary mock data
/// matching the 15 approved Google Stitch reference screens.
class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _languageCode = 'ar';
  bool _agriculturalNotifications = true;
  String _lastSyncText = 'اليوم، 10:30 ص';

  // User Profile (Screen 13 `agritech_13`)
  // Enforces business rule: accounts created via registration are 'مزارع' (Farmer);
  // administrator privileges cannot be self-granted without authorization.
  String userFullName = 'مستخدم جديد';
  String userEmail = 'user@agritech.ye';
  String userPhone = '+967 77X XXX XXX';
  String userRole = 'مزارع';
  String userGovernorate = 'صنعاء';
  String userDistrict = 'مديرية بني حشيش';

  int selectedFarmIndex = 0;
  int selectedSensorIndex = 0;

  // Plant Disease Diagnosis image state (Screen 7 `agritech_14`)
  String? capturedOriginalImagePath;
  String? preprocessedModelImagePath;
  String? diagnosisImageSource; // 'camera' | 'gallery'
  bool isDiagnosisImageConfirmed = false;

  // Temporary local mock support requests (Screen 14/15 Support Modal)
  final List<Map<String, String>> localSupportRequests = [];

  ThemeMode get themeMode => _themeMode;
  String get languageCode => _languageCode;
  bool get isArabic => _languageCode == 'ar';
  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;
  bool get agriculturalNotifications => _agriculturalNotifications;
  String get lastSyncText => _lastSyncText;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  void toggleThemeMode() {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    notifyListeners();
  }

  void setLanguageCode(String code) {
    if (_languageCode != code) {
      _languageCode = code;
      notifyListeners();
    }
  }

  void setAgriculturalNotifications(bool enabled) {
    _agriculturalNotifications = enabled;
    notifyListeners();
  }

  void triggerManualSync() {
    _lastSyncText = 'الآن (محدّث)';
    notifyListeners();
  }

  void submitLocalSupportRequest({
    required String requestType,
    required String title,
    required String description,
    required String contactMethod,
    required String contactValue,
  }) {
    localSupportRequests.insert(0, {
      'type': requestType,
      'title': title,
      'description': description,
      'contactMethod': contactMethod,
      'contactValue': contactValue,
      'createdAt': DateTime.now().toIso8601String(),
    });
    notifyListeners();
  }

  void setDiagnosisCapturedImage({
    required String originalPath,
    String? preprocessedPath,
    required String source,
    bool confirmed = false,
  }) {
    capturedOriginalImagePath = originalPath;
    preprocessedModelImagePath = preprocessedPath ?? originalPath;
    diagnosisImageSource = source;
    isDiagnosisImageConfirmed = confirmed;
    notifyListeners();
  }

  void confirmDiagnosisImage() {
    if (capturedOriginalImagePath != null) {
      isDiagnosisImageConfirmed = true;
      notifyListeners();
    }
  }

  void clearDiagnosisImage() {
    capturedOriginalImagePath = null;
    preprocessedModelImagePath = null;
    diagnosisImageSource = null;
    isDiagnosisImageConfirmed = false;
    notifyListeners();
  }

  void updateProfile({
    required String fullName,
    required String email,
    required String phone,
    required String governorate,
    required String district,
  }) {
    userFullName = fullName;
    userEmail = email;
    userPhone = phone;
    userGovernorate = governorate;
    userDistrict = district;
    notifyListeners();
  }

  void selectFarm(int index) {
    if (index >= 0 && index < farms.length) {
      selectedFarmIndex = index;
      notifyListeners();
    }
  }

  void selectSensor(int index) {
    if (index >= 0 && index < sensors.length) {
      selectedSensorIndex = index;
      notifyListeners();
    }
  }

  void updateSensorReadingValue(int index, String newValue) {
    if (index >= 0 && index < sensors.length) {
      sensors[index].currentValue = newValue;
      notifyListeners();
    }
  }

  // --- Temporary Mock Farms (Screen 11 `agritech_12`) ---
  final List<FarmModel> farms = [
    FarmModel(
      id: 'farm_1',
      name: 'مزرعة البن الرئيسية',
      location: 'حرض الغربية',
      regionSubtitle: 'المرتفعات الغربية - حرض',
      areaHectares: 2.2,
      cropType: 'بن يمني أصيل',
      featureBadge: 'بن يمني أصيل',
      connectedSensors: 8,
      bannerAsset: 'lib/assets/images/farm_banner_1.png',
      notes: 'مدرجات زراعية مجهزة بحساسات رطوبة التربة والمناخ.',
      registeredSensors: const [
        FarmSensorSummaryModel(
          name: 'مجس رطوبة التربة (YL-69 - حقل 1)',
          type: 'soil',
          statusLabel: 'متصل',
        ),
        FarmSensorSummaryModel(
          name: 'حساس درجة حرارة الهواء والرطوبة (DHT22)',
          type: 'temp',
          statusLabel: 'متصل',
        ),
        FarmSensorSummaryModel(
          name: 'وحدة الإرسال اللاسلكي (ESP32 DevKit)',
          type: 'humidity',
          statusLabel: 'متصل',
        ),
      ],
    ),
    FarmModel(
      id: 'farm_2',
      name: 'مزرعة حقل البن الشرقي',
      location: 'مناخة',
      regionSubtitle: 'مناخة - جبال حراز',
      areaHectares: 1.5,
      cropType: 'بن يمني دوائري',
      featureBadge: 'مدرجات جبلية',
      connectedSensors: 6,
      bannerAsset: 'lib/assets/images/farm_banner_2.png',
      notes: 'مدرجات مرتفعة تعتمد على الري بالتنقيط الذكي.',
      registeredSensors: const [
        FarmSensorSummaryModel(
          name: 'مجس رطوبة التربة (YL-69 - القطاع الشرقي)',
          type: 'soil',
          statusLabel: 'متصل',
        ),
        FarmSensorSummaryModel(
          name: 'حساس الحرارة والرطوبة النسبية (DHT22)',
          type: 'temp',
          statusLabel: 'متصل',
        ),
      ],
    ),
    FarmModel(
      id: 'farm_3',
      name: 'مزرعة وادي بني مطر',
      location: 'بني مطر',
      regionSubtitle: 'بني مطر - صنعاء',
      areaHectares: 0.8,
      cropType: 'بن يمني مطري',
      featureBadge: 'ري بالوديان',
      connectedSensors: 4,
      bannerAsset: 'lib/assets/images/farm_banner_3.png',
      notes: 'مزرعة وادي خصبة لإنتاج البن المطري المختص.',
      registeredSensors: const [
        FarmSensorSummaryModel(
          name: 'مجس رطوبة التربة (YL-69 - الوادي)',
          type: 'soil',
          statusLabel: 'متصل',
        ),
        FarmSensorSummaryModel(
          name: 'حساس مناخ المدرجات (DHT22)',
          type: 'temp',
          statusLabel: 'متصل',
        ),
      ],
    ),
  ];

  void addFarm({
    required String name,
    required String location,
    required double areaHectares,
    required String cropType,
    String notes = '',
  }) {
    farms.insert(
      0,
      FarmModel(
        id: 'farm_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        location: location,
        regionSubtitle: location,
        areaHectares: areaHectares,
        cropType: cropType,
        featureBadge: cropType,
        connectedSensors: 4,
        bannerAsset: 'lib/assets/images/farm_banner_1.png',
        notes: notes,
        registeredSensors: const [
          FarmSensorSummaryModel(
            name: 'مجس رطوبة التربة (حقل 1)',
            type: 'soil',
            statusLabel: 'متصل',
          ),
          FarmSensorSummaryModel(
            name: 'حساس درجة حرارة الهواء والرطوبة',
            type: 'temp',
            statusLabel: 'متصل',
          ),
        ],
      ),
    );
    notifyListeners();
  }

  void updateFarm(
    String id, {
    required String name,
    required String location,
    required double areaHectares,
    required String cropType,
    required String notes,
  }) {
    final idx = farms.indexWhere((f) => f.id == id);
    if (idx != -1) {
      farms[idx]
        ..name = name
        ..location = location
        ..regionSubtitle = location
        ..areaHectares = areaHectares
        ..cropType = cropType
        ..featureBadge = cropType
        ..notes = notes;
      notifyListeners();
    }
  }

  // --- Temporary Mock Sensors (Screen 6 `agritech_9`) ---
  // Configured with explicit minThreshold / maxThreshold and agricultural rules.
  final List<SensorItemModel> sensors = [
    SensorItemModel(
      id: 'SEN-TMP-204',
      name: 'حساس درجة الحرارة (القطاع 1 - حقل البن الجنوبي)',
      shortName: 'حساس درجة الحرارة (حقل البن الجنوبي)',
      measurementType: 'درجة الحرارة الجوية (°C)',
      currentValue: '24.5',
      unit: '°C',
      idealRangeText: 'ضمن النطاق الموصى به (20°C - 27°C)',
      statusText: 'متصل ومستقر',
      isOnline: true,
      farmName: 'مزرعة البن الرئيسية',
      farmRegion: 'المرتفعات الغربية',
      lastUpdated: 'منذ 5 دقائق',
      protocol: 'LoRaWAN v1.2',
      updateInterval: 'كل 15 دقيقة',
      iconType: 'temp',
      minThreshold: 20.0,
      maxThreshold: 27.0,
      optimalRangeLabel: 'النطاق المثالي لأشجار البن (20° - 27°)',
      recentReadings: const [
        SensorReadingLogEntry(
          value: '24.5',
          unit: '°C',
          timeText: 'اليوم - 10:45 ص',
          statusLabel: 'طبيعي',
          isWarning: false,
        ),
        SensorReadingLogEntry(
          value: '23.8',
          unit: '°C',
          timeText: 'اليوم - 09:45 ص',
          statusLabel: 'طبيعي',
          isWarning: false,
        ),
        SensorReadingLogEntry(
          value: '21.2',
          unit: '°C',
          timeText: 'اليوم - 08:45 ص',
          statusLabel: 'طبيعي',
          isWarning: false,
        ),
        SensorReadingLogEntry(
          value: '19.5',
          unit: '°C',
          timeText: 'اليوم - 07:45 ص',
          statusLabel: 'منخفض طفيف',
          isWarning: true,
        ),
      ],
    ),
    SensorItemModel(
      id: 'SEN-HUM-108',
      name: 'حساس رطوبة الهواء (القطاع 1 - حقل البن الجنوبي)',
      shortName: 'حساس رطوبة الهواء (حقل البن الجنوبي)',
      measurementType: 'الرطوبة النسبية للجو (%)',
      currentValue: '68',
      unit: '%',
      idealRangeText: 'ضمن النطاق الموصى به (50% - 70%)',
      statusText: 'متصل ومستقر',
      isOnline: true,
      farmName: 'مزرعة البن الرئيسية',
      farmRegion: 'المرتفعات الغربية',
      lastUpdated: 'منذ 8 دقائق',
      protocol: 'LoRaWAN v1.2',
      updateInterval: 'كل 15 دقيقة',
      iconType: 'humidity',
      minThreshold: 50.0,
      maxThreshold: 70.0,
      optimalRangeLabel: 'النطاق المثالي لرطوبة الجو (50% - 70%)',
      recentReadings: const [
        SensorReadingLogEntry(
          value: '68',
          unit: '%',
          timeText: 'اليوم - 10:45 ص',
          statusLabel: 'طبيعي',
          isWarning: false,
        ),
        SensorReadingLogEntry(
          value: '70',
          unit: '%',
          timeText: 'اليوم - 09:45 ص',
          statusLabel: 'طبيعي',
          isWarning: false,
        ),
        SensorReadingLogEntry(
          value: '73',
          unit: '%',
          timeText: 'اليوم - 08:45 ص',
          statusLabel: 'مرتفع نسبياً',
          isWarning: true,
        ),
        SensorReadingLogEntry(
          value: '65',
          unit: '%',
          timeText: 'اليوم - 07:45 ص',
          statusLabel: 'طبيعي',
          isWarning: false,
        ),
      ],
    ),
    SensorItemModel(
      id: 'SEN-SOIL-312',
      name: 'حساس رطوبة التربة (القطاع 2 - حقل البن الشرقي)',
      shortName: 'حساس رطوبة التربة (حقل البن الشرقي)',
      measurementType: 'رطوبة التربة الحجمية (%)',
      currentValue: '24',
      unit: '%',
      idealRangeText: 'انخفاض عن النطاق الموصى به (30% - 50%)',
      statusText: 'متصل ومستقر',
      isOnline: true,
      farmName: 'مزرعة البن الرئيسية',
      farmRegion: 'المرتفعات الغربية',
      lastUpdated: 'منذ 12 دقيقة',
      protocol: 'LoRaWAN v1.2',
      updateInterval: 'كل 15 دقيقة',
      iconType: 'soil',
      minThreshold: 30.0,
      maxThreshold: 50.0,
      optimalRangeLabel: 'النطاق المطلوب لجذور البن (30% - 50%)',
      recentReadings: const [
        SensorReadingLogEntry(
          value: '24',
          unit: '%',
          timeText: 'اليوم - 10:30 ص',
          statusLabel: 'منخفض - يحتاج ري',
          isWarning: true,
        ),
        SensorReadingLogEntry(
          value: '27',
          unit: '%',
          timeText: 'اليوم - 10:00 ص',
          statusLabel: 'منخفض طفيف',
          isWarning: true,
        ),
        SensorReadingLogEntry(
          value: '32',
          unit: '%',
          timeText: 'اليوم - 09:30 ص',
          statusLabel: 'طبيعي',
          isWarning: false,
        ),
        SensorReadingLogEntry(
          value: '35',
          unit: '%',
          timeText: 'اليوم - 09:00 ص',
          statusLabel: 'طبيعي',
          isWarning: false,
        ),
      ],
    ),
    SensorItemModel(
      id: 'SEN-VLV-401',
      name: 'حساس تدفق شبكة الري (القطاع الغربي)',
      shortName: 'حساس تدفق شبكة الري (القطاع الغربي)',
      measurementType: 'معدل تدفق المياه (L/min)',
      currentValue: '0.0',
      unit: 'L/min',
      idealRangeText: 'المحبس مغلق / انقطاع إشارة',
      statusText: 'غير متصل',
      isOnline: false,
      farmName: 'مزرعة البن الرئيسية',
      farmRegion: 'المرتفعات الغربية',
      lastUpdated: 'منذ 30 دقيقة',
      protocol: 'LoRaWAN v1.2',
      updateInterval: 'كل 15 دقيقة',
      iconType: 'valve',
      minThreshold: 15.0,
      maxThreshold: 35.0,
      optimalRangeLabel: 'معدل التدفق القياسي لخط الري (15 - 35 L/min)',
      recentReadings: const [
        SensorReadingLogEntry(
          value: '0.0',
          unit: 'L/min',
          timeText: 'اليوم - 07:45 ص',
          statusLabel: 'انقطاع إشارة',
          isWarning: true,
        ),
        SensorReadingLogEntry(
          value: '22.4',
          unit: 'L/min',
          timeText: 'أمس - 06:00 م',
          statusLabel: 'طبيعي',
          isWarning: false,
        ),
        SensorReadingLogEntry(
          value: '23.1',
          unit: 'L/min',
          timeText: 'أمس - 12:00 م',
          statusLabel: 'طبيعي',
          isWarning: false,
        ),
        SensorReadingLogEntry(
          value: '21.8',
          unit: 'L/min',
          timeText: 'أمس - 06:00 ص',
          statusLabel: 'طبيعي',
          isWarning: false,
        ),
      ],
    ),
  ];

  // --- Temporary Mock Diagnosis History (Screens 8 & 9 `agritech_6`, `agritech_4`) ---
  final List<DiagnosisRecordModel> diagnosisHistory = const [
    DiagnosisRecordModel(
      id: 'diag_1',
      diseaseName: 'صدأ أوراق البن',
      scientificName: 'Coffee Leaf Rust (Hemileia vastatrix)',
      statusLabel: 'إصابة مؤكدة',
      statusType: 'confirmed',
      farmName: 'مزرعة البن الرئيسية',
      timestamp: 'اليوم، 11:20 ص',
      confidencePercent: 94,
      actionSummary: 'إجراءات مقترحة (3)',
      badgeLabel: 'ميداني',
      thumbnailAsset: 'lib/assets/images/diag_thumb_rust.png',
      description:
          'فطر يصيب أوراق البن ويظهر على شكل بقع صفراء برتقالية مسحوقية على السطح السفلي للأوراق، ويؤدي إلى تساقطها وضعف المحصول. يعتبر من أخطر التحديات التي تهدد جودة حبوب القهوة وإنتاجية المصاطب الجبلية إذا لم يتم التدخل السريع.',
      severityLabel: 'متوسط إلى حاد',
      incubationLabel: '10 - 14 يوماً',
    ),
    DiagnosisRecordModel(
      id: 'diag_2',
      diseaseName: 'التبقع البني (Cercospora)',
      scientificName: 'Cercospora coffeicola',
      statusLabel: 'قيد المتابعة',
      statusType: 'followup',
      farmName: 'مزرعة المرتفعات',
      timestamp: 'أمس، 04:15 م',
      confidencePercent: 88,
      actionSummary: 'تسميد مقترح',
      badgeLabel: 'ميداني',
      thumbnailAsset: 'lib/assets/images/diag_thumb_cercospora.png',
      description:
          'بقع دائرية بنية ذات مركز فاتح وحواف داكنة تظهر على الأوراق نتيجة نقص التغذية النيتروجينية أو الإجهاد المائي الموضعي.',
      severityLabel: 'متوسط',
      incubationLabel: '7 - 10 أيام',
    ),
    DiagnosisRecordModel(
      id: 'diag_3',
      diseaseName: 'أوراق سليمة - لا توجد إصابة',
      scientificName: 'Coffea arabica (Healthy Foliage)',
      statusLabel: 'سليمة',
      statusType: 'healthy',
      farmName: 'حقل البن الشرقي',
      timestamp: '22 أكتوبر',
      confidencePercent: 96,
      actionSummary: 'محصول واعد',
      badgeLabel: 'سليم',
      thumbnailAsset: 'lib/assets/images/diag_thumb_healthy.png',
      description:
          'الأوراق تتمتع بحيوية عالية ولون أخضر داكن متجانس مع خلوّها من أي مؤشرات فطرية أو حشرية.',
      severityLabel: 'لا يوجد خطر',
      incubationLabel: '-',
    ),
  ];

  // --- Temporary Mock Agricultural Recommendations (Screen 10 `agritech_7`) ---
  final List<RecommendationModel> recommendations = [
    RecommendationModel(
      id: 'rec_1',
      title: 'توصية ري عاجلة - قطاع النخيل الغربي',
      sectorAndTime: 'قطاع A2 • منذ 25 دقيقة',
      priority: 'عاجلة',
      metricTitle: 'رطوبة التربة الحالية:',
      metricValue: '18% VWC',
      metricTarget: '(الهدف: 32%)',
      diagnosisText:
          'انخفاض رطوبة التربة عن الحد الأدنى المسموح به للنخيل المثمر بسبب ارتفاع التبخر الميداني. هناك خطر حدوث إجهاد مائي يؤثر على عقد الثمار.',
      actionText:
          'تشغيل نظام الري بالتنقيط للقطاع الغربي لمدة 45 دقيقة فوراً (معدل تدفق 120 لتر/شجرة) قبل اشتداد حرارة الظهيرة.',
      actionButtonLabel: 'تنفيذ الري وتوثيق الإجراء',
      categoryType: 'water',
    ),
    RecommendationModel(
      id: 'rec_2',
      title: 'تعديل جدول التسميد - حقل البن الجنوبي',
      sectorAndTime: 'قطاع C1 • منذ ساعة واحدة',
      priority: 'متوسطة',
      metricTitle: 'درجة حرارة الحقل:',
      metricValue: '28.5°C',
      metricTarget: '(النيتروجين: منخفض)',
      diagnosisText:
          'تحليل العناصر المغذية أظهر انخفاضاً تدريجياً في مستوى النيتروجين المتاح في منطقة الجذور مع بدء مرحلة تكوين حبوب البن.',
      actionText:
          'إضافة محلول نترات البوتاسيوم بتركيز 2.5 جم/لتر مع ري المساء لتفادي تبخر الأسمدة وتعزيز الامتصاص.',
      actionButtonLabel: 'تأكيد جدولة التسميد',
      categoryType: 'fertilizer',
    ),
    RecommendationModel(
      id: 'rec_3',
      title: 'متابعة رطوبة الهواء - حقل البن الجنوبي',
      sectorAndTime: 'القطاع 1 • منذ ساعتين',
      priority: 'عاجلة',
      metricTitle: 'رطوبة الهواء النسبية:',
      metricValue: '74% RH',
      metricTarget: '(النطاق الموصى به: 50% - 70%)',
      diagnosisText:
          'ارتفاع رطوبة الهواء المحيطة بأشجار البن عن النطاق المثالي، مما يستدعي مراقبة التهوية الطبيعية بين المدرجات لتفادي نشاط الفطريات.',
      actionText:
          'تفقد تصريف الهواء الطبيعي والتحقق من حالة رطوبة أوراق البن واتباع الإجراءات الوقائية المعتمدة.',
      actionButtonLabel: 'تأكيد المراجعة الحقلية',
      categoryType: 'air',
    ),
  ];

  void completeRecommendation(String id) {
    final idx = recommendations.indexWhere((r) => r.id == id);
    if (idx != -1) {
      recommendations[idx].isCompleted = true;
      notifyListeners();
    }
  }

  // --- Temporary Mock Products (Screen 12 `agritech_5`) ---
  final List<ProductModel> products = [
    ProductModel(
      id: 'prod_1',
      name: 'بن حرازي مجفف طبيعي',
      category: 'بن مختص',
      originBadge: 'حرازي',
      description:
          'محصول حرازي غني بالنكهات الفاكهية والشوكولاتة من مرتفعات حراز.',
      quantity: 80,
      unit: 'كجم',
      price: 50,
      currency: '\$',
      farmName: 'مزرعة حقل البن الشرقي - مناخة',
      location: 'مناخة، صنعاء، اليمن',
      addedDate: '15 أكتوبر 2024',
      status: 'منشور',
      imageAsset: 'lib/assets/images/product_thumb_harazi.png',
      galleryAssets: const [
        'lib/assets/images/product_thumb_harazi.png',
        'lib/assets/images/product_thumb_yafei.png',
        'lib/assets/images/farm_banner_2.png',
      ],
      reservations: const [
        ProductReservationModel(
          buyerName: 'مقهى السحاب - الرياض',
          quantityLabel: 'كمية الحجز: 50 كجم',
          status: 'قيد المعالجة',
          isConfirmed: false,
        ),
        ProductReservationModel(
          buyerName: 'محمصة الأصالة - صنعاء',
          quantityLabel: 'كمية الحجز: 25 كجم',
          status: 'مؤكد',
          isConfirmed: true,
        ),
      ],
    ),
    ProductModel(
      id: 'prod_2',
      name: 'بن مطري محمص خفيف',
      category: 'بن محمص',
      originBadge: 'مطري',
      description:
          'تحميص مخصص للفلتر والإسبريسو، قوام متوازن وحمضية فاكهية لطيفة.',
      quantity: 40,
      unit: 'كجم',
      price: 38,
      currency: '\$',
      farmName: 'مزرعة وادي بني مطر',
      location: 'بني مطر، صنعاء، اليمن',
      addedDate: '18 أكتوبر 2024',
      status: 'بانتظار المراجعة',
      imageAsset: 'lib/assets/images/product_thumb_harazi.png',
      galleryAssets: const [
        'lib/assets/images/product_thumb_harazi.png',
        'lib/assets/images/farm_banner_3.png',
      ],
      reservations: const [],
    ),
    ProductModel(
      id: 'prod_3',
      name: 'بن يافعي درجة أولى',
      category: 'بن أخضر مجفف',
      originBadge: 'يافعي',
      description:
          'حبوب بن يافعي أصيلة مختارة يدوياً من أعالي المدرجات الجبلية.',
      quantity: 120,
      unit: 'كجم',
      price: 60,
      currency: '\$',
      farmName: 'مزرعة البن الرئيسية - المرتفعات الغربية (حرض)',
      location: 'المرتفعات الغربية، حرض، اليمن',
      addedDate: '20 أكتوبر 2024',
      status: 'منشور',
      imageAsset: 'lib/assets/images/product_thumb_yafei.png',
      galleryAssets: const [
        'lib/assets/images/product_thumb_yafei.png',
        'lib/assets/images/product_thumb_harazi.png',
        'lib/assets/images/farm_banner_1.png',
      ],
      reservations: const [
        ProductReservationModel(
          buyerName: 'شركة القهوة المختصة - جدة',
          quantityLabel: 'كمية الحجز: 60 كجم',
          status: 'مؤكد',
          isConfirmed: true,
        ),
        ProductReservationModel(
          buyerName: 'محمصة القمة - عدن',
          quantityLabel: 'كمية الحجز: 30 كجم',
          status: 'قيد المعالجة',
          isConfirmed: false,
        ),
      ],
    ),
  ];

  void addProduct(ProductModel product) {
    products.insert(0, product);
    notifyListeners();
  }

  void updateProduct(String id, ProductModel updated) {
    final idx = products.indexWhere((p) => p.id == id);
    if (idx != -1) {
      products[idx] = updated;
      notifyListeners();
    }
  }
}

/// InheritedNotifier providing [AppState] across the widget tree.
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required super.notifier,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null && scope.notifier != null, 'AppStateScope not found');
    return scope!.notifier!;
  }

  static AppState? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppStateScope>()
        ?.notifier;
  }
}
