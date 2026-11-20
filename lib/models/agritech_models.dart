// Data models for the AgriTech mobile application.
// Currently populated with clearly identified temporary mock data to
// demonstrate the 15 approved Google Stitch interfaces, ready for future
// Firebase / local database / sensor integration.
//
// NOTE ON ADMINISTRATOR INTERFACES:
// Administrator management interfaces (managing plant diseases, treatments,
// agricultural rules, and recommendations) are not part of the current 15
// approved Stitch screens and are reserved for a future approved design phase.

class FarmSensorSummaryModel {
  const FarmSensorSummaryModel({
    required this.name,
    required this.type, // 'soil', 'temp', 'humidity', 'valve'
    required this.statusLabel,
    this.isConnected = true,
  });

  final String name;
  final String type;
  final String statusLabel;
  final bool isConnected;
}

class FarmModel {
  FarmModel({
    required this.id,
    required this.name,
    required this.location,
    required this.regionSubtitle,
    required this.areaHectares,
    required this.cropType,
    required this.featureBadge,
    required this.connectedSensors,
    required this.bannerAsset,
    this.isActive = true,
    this.notes = '',
    this.registeredSensors = const [],
  });

  final String id;
  String name;
  String location;
  String regionSubtitle;
  double areaHectares;
  String cropType;
  String featureBadge;
  int connectedSensors;
  final String bannerAsset;
  bool isActive;
  String notes;
  List<FarmSensorSummaryModel> registeredSensors;
}

class ProductReservationModel {
  const ProductReservationModel({
    required this.buyerName,
    required this.quantityLabel,
    required this.status,
    required this.isConfirmed,
  });

  final String buyerName;
  final String quantityLabel;
  final String status;
  final bool isConfirmed;
}

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.originBadge,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.price,
    required this.currency,
    required this.farmName,
    required this.location,
    required this.addedDate,
    required this.status, // 'منشور', 'بانتظار المراجعة', 'مسودة'
    this.imageAsset,
    this.galleryAssets = const [],
    this.reservations = const [],
  });

  final String id;
  String name;
  String category;
  String originBadge;
  String description;
  double quantity;
  String unit;
  double price;
  String currency;
  String farmName;
  String location;
  final String addedDate;
  String status;
  String? imageAsset;
  List<String> galleryAssets;
  List<ProductReservationModel> reservations;

  List<String> get allImages {
    final result = <String>[];
    if (imageAsset != null && imageAsset!.isNotEmpty) {
      result.add(imageAsset!);
    }
    for (final img in galleryAssets) {
      if (!result.contains(img)) {
        result.add(img);
      }
    }
    return result;
  }
}

class DiagnosisRecordModel {
  const DiagnosisRecordModel({
    required this.id,
    required this.diseaseName,
    required this.scientificName,
    required this.statusLabel,
    required this.statusType, // 'confirmed', 'followup', 'healthy'
    required this.farmName,
    required this.timestamp,
    required this.confidencePercent,
    required this.actionSummary,
    required this.badgeLabel,
    required this.thumbnailAsset,
    required this.description,
    required this.severityLabel,
    required this.incubationLabel,
  });

  final String id;
  final String diseaseName;
  final String scientificName;
  final String statusLabel;
  final String statusType;
  final String farmName;
  final String timestamp;
  final int confidencePercent;
  final String actionSummary;
  final String badgeLabel;
  final String thumbnailAsset;
  final String description;
  final String severityLabel;
  final String incubationLabel;
}

class RecommendationModel {
  RecommendationModel({
    required this.id,
    required this.title,
    required this.sectorAndTime,
    required this.priority, // 'عاجلة', 'متوسطة', 'منخفضة'
    required this.metricTitle,
    required this.metricValue,
    required this.metricTarget,
    required this.diagnosisText,
    required this.actionText,
    required this.actionButtonLabel,
    required this.categoryType, // 'water', 'fertilizer', 'air'
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String sectorAndTime;
  final String priority;
  final String metricTitle;
  final String metricValue;
  final String metricTarget;
  final String diagnosisText;
  final String actionText;
  final String actionButtonLabel;
  final String categoryType;
  bool isCompleted;
}

class SensorReadingLogEntry {
  const SensorReadingLogEntry({
    required this.value,
    required this.unit,
    required this.timeText,
    required this.statusLabel,
    required this.isWarning,
  });

  final String value;
  final String unit;
  final String timeText;
  final String statusLabel;
  final bool isWarning;
}

/// Result of evaluating a sensor reading against its configured agricultural
/// thresholds (temporary mock agricultural rules for Coffea arabica).
class SensorRuleEvaluation {
  const SensorRuleEvaluation({
    required this.state, // 'normal', 'low', 'high', 'disconnected'
    required this.badgeText,
    required this.directionLabel,
    required this.recommendationTitle,
    required this.diagnosisText,
    required this.recommendedAction,
    required this.chartFooterStatus,
  });

  final String state;
  final String badgeText;
  final String directionLabel;
  final String recommendationTitle;
  final String diagnosisText;
  final String recommendedAction;
  final String chartFooterStatus;

  bool get isOutOfRange => state == 'low' || state == 'high';
  bool get isNormal => state == 'normal';
  bool get isDisconnected => state == 'disconnected';
}

class SensorItemModel {
  SensorItemModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.measurementType,
    required this.currentValue,
    required this.unit,
    required this.idealRangeText,
    required this.statusText,
    required this.isOnline,
    required this.farmName,
    required this.farmRegion,
    required this.lastUpdated,
    required this.protocol,
    required this.updateInterval,
    required this.iconType, // 'temp', 'humidity', 'soil', 'valve'
    required this.minThreshold,
    required this.maxThreshold,
    required this.optimalRangeLabel,
    required this.recentReadings,
  });

  final String id;
  final String name;
  final String shortName;
  final String measurementType;
  String currentValue;
  final String unit;
  final String idealRangeText;
  final String statusText;
  final bool isOnline;
  final String farmName;
  final String farmRegion;
  final String lastUpdated;
  final String protocol;
  final String updateInterval;
  final String iconType;
  final double minThreshold;
  final double maxThreshold;
  final String optimalRangeLabel;
  final List<SensorReadingLogEntry> recentReadings;

  /// Evaluates [currentValue] against [minThreshold] and [maxThreshold] using
  /// clearly labeled temporary mock agricultural rules for Yemeni coffee crops.
  SensorRuleEvaluation evaluateReading() {
    if (!isOnline) {
      return const SensorRuleEvaluation(
        state: 'disconnected',
        badgeText: 'انقطاع الاتصال - القراءة خارج النطاق التشغيلي',
        directionLabel: 'انقطاع إشارة الحساس (0.0 L/min)',
        recommendationTitle: 'تنبيه تشغيلي عاجل — انقطاع الاتصال',
        diagnosisText:
            'الحساس غير متصل بالشبكة حالياً ولا توجد قراءات تدفق لحظية من المحبس.',
        recommendedAction:
            'فحص مزود الطاقة لبطارية الحساس أو مكرر الإشارة اللاسلكية والتحقق من محبس الري في القطاع الغربي.',
        chartFooterStatus: 'توقف تدفق أو انقطاع إشارة الحساس',
      );
    }

    final val = double.tryParse(currentValue) ?? minThreshold;
    final rangeStr =
        '${minThreshold.toStringAsFixed(minThreshold.truncateToDouble() == minThreshold ? 0 : 1)}$unit - '
        '${maxThreshold.toStringAsFixed(maxThreshold.truncateToDouble() == maxThreshold ? 0 : 1)}$unit';

    if (val < minThreshold) {
      switch (iconType) {
        case 'soil':
          return SensorRuleEvaluation(
            state: 'low',
            badgeText: 'خارج النطاق (منخفض عن الحد الأدنى $rangeStr)',
            directionLabel:
                'القراءة منخفضة جداً ($currentValue$unit < ${minThreshold.toInt()}$unit)',
            recommendationTitle: 'تنبيه: انخفاض رطوبة التربة — يوصى بالري',
            diagnosisText:
                'انخفضت رطوبة التربة الحالية ($currentValue$unit) عن الحد الأدنى الموصى به لأشجار البن (${minThreshold.toInt()}% - ${maxThreshold.toInt()}%)، مما يعرض الجذور للإجهاد المائي.',
            recommendedAction:
                'تشغيل نظام الري بالتنقيط فوراً لمدة 35 - 45 دقيقة لرفع رطوبة التربة إلى النطاق المثالي (${minThreshold.toInt()}% - ${maxThreshold.toInt()}%).',
            chartFooterStatus: 'انخفاض رطوبة التربة — يتطلب ري',
          );
        case 'temp':
          return SensorRuleEvaluation(
            state: 'low',
            badgeText: 'خارج النطاق (منخفض عن الحد الأدنى $rangeStr)',
            directionLabel:
                'درجة الحرارة منخفضة ($currentValue$unit < ${minThreshold.toInt()}$unit)',
            recommendationTitle:
                'تنبيه: انخفاض درجة الحرارة عن النطاق الموصى به',
            diagnosisText:
                'درجة الحرارة الحالية ($currentValue$unit) أقل من الحد الأدنى الملائم لنشاط نمو أشجار البن (${minThreshold.toInt()}°C - ${maxThreshold.toInt()}°C).',
            recommendedAction:
                'مراقبة احتمالية البرودة الليلية في المدرجات وتجنب الرش الورقي أو الري الغزير في ساعات المساء المتأخرة.',
            chartFooterStatus: 'انخفاض حراري يحتاج متابعة',
          );
        case 'humidity':
        default:
          return SensorRuleEvaluation(
            state: 'low',
            badgeText: 'خارج النطاق (منخفض عن الحد الأدنى $rangeStr)',
            directionLabel:
                'رطوبة الهواء منخفضة ($currentValue$unit < ${minThreshold.toInt()}$unit)',
            recommendationTitle: 'تنبيه: جفاف نسبي في الهواء المحيط بالمحصول',
            diagnosisText:
                'انخفضت الرطوبة النسبية للهواء ($currentValue$unit) عن النطاق الموصى به (${minThreshold.toInt()}% - ${maxThreshold.toInt()}%) مما يزيد من معدل النتح.',
            recommendedAction:
                'فحص مستوى رطوبة التربة وتعويض الفاقد المائي عبر ري تنقيط خفيف لتقليل إجهاد الأوراق.',
            chartFooterStatus: 'انخفاض في الرطوبة الجوية',
          );
      }
    }

    if (val > maxThreshold) {
      switch (iconType) {
        case 'soil':
          return SensorRuleEvaluation(
            state: 'high',
            badgeText: 'خارج النطاق (مرتفع عن الحد الأعلى $rangeStr)',
            directionLabel:
                'القراءة مرتفعة جداً ($currentValue$unit > ${maxThreshold.toInt()}$unit)',
            recommendationTitle: 'تنبيه: ارتفاع رطوبة التربة — فحص حالة الري',
            diagnosisText:
                'تجاوزت رطوبة التربة ($currentValue$unit) الحد الأعلى المسموح به (${maxThreshold.toInt()}%)، مما قد يقلل تهوية الجذور ويزيد خطر أعفان الجذور.',
            recommendedAction:
                'إيقاف دورة الري الحالية والتحقق من عدم وجود تسريب في أنابيب التنقيط والتأكد من سلامة تصريف المياه في المدرج.',
            chartFooterStatus: 'تشبع مائي — يرجى فحص شبكة الري',
          );
        case 'temp':
          return SensorRuleEvaluation(
            state: 'high',
            badgeText: 'خارج النطاق (مرتفع عن الحد الأعلى $rangeStr)',
            directionLabel:
                'درجة الحرارة مرتفعة ($currentValue$unit > ${maxThreshold.toInt()}$unit)',
            recommendationTitle:
                'تنبيه: ارتفاع درجة الحرارة عن النطاق الموصى به',
            diagnosisText:
                'تجاوزت درجة حرارة الحقل ($currentValue$unit) الحد الأعلى الموصى به (${maxThreshold.toInt()}°C)، مما يرفع معدلات التبخر والإجهاد الحراري لأشجار البن.',
            recommendedAction:
                'جدولة رية تكميلية خفيفة قبل ذروة الظهيرة وتأجيل أي عمليات تسميد أو رش ورقي حتى اعتدال الحرارة مساءً.',
            chartFooterStatus: 'ارتفاع حراري يتطلب تبريد/ري وقائي',
          );
        case 'humidity':
        default:
          return SensorRuleEvaluation(
            state: 'high',
            badgeText: 'خارج النطاق (مرتفع عن الحد الأعلى $rangeStr)',
            directionLabel:
                'رطوبة الهواء مرتفعة ($currentValue$unit > ${maxThreshold.toInt()}$unit)',
            recommendationTitle: 'تنبيه: ارتفاع رطوبة الهواء — خطر نشاط فطري',
            diagnosisText:
                'ارتفعت رطوبة الهواء النسبية ($currentValue$unit) فوق النطاق الموصى به (${minThreshold.toInt()}% - ${maxThreshold.toInt()}%)، وهي بيئة محفزة لانتشار فطر صدأ أوراق البن.',
            recommendedAction:
                'تفقد التهوية الطبيعية بين أشجار البن وفحص السطح السفلي للأوراق لرصد أي بقع مبكرة لصدأ الأوراق.',
            chartFooterStatus: 'رطوبة مرتفعة — يوصى بفحص التهوية',
          );
      }
    }

    // Within acceptable range
    switch (iconType) {
      case 'soil':
        return SensorRuleEvaluation(
          state: 'normal',
          badgeText: 'ضمن النطاق الموصى به ($rangeStr)',
          directionLabel: 'ضمن المعدل الطبيعي ($currentValue$unit)',
          recommendationTitle: 'توصية زراعية لحظية — حالة طبيعية',
          diagnosisText:
              'نسبة رطوبة التربة الحالية ($currentValue$unit) مثالية لجذور أشجار البن وتقع ضمن النطاق المعتمد ($rangeStr).',
          recommendedAction:
              'الاستمرار على جدول الري المعتاد دون الحاجة لري إضافي حالياً (دورة الري القادمة مجدولة بعد 6 ساعات).',
          chartFooterStatus: 'ري كافٍ ورطوبة مثالية',
        );
      case 'humidity':
        return SensorRuleEvaluation(
          state: 'normal',
          badgeText: 'ضمن النطاق الموصى به ($rangeStr)',
          directionLabel: 'ضمن المعدل الطبيعي ($currentValue$unit)',
          recommendationTitle: 'توصية زراعية لحظية — حالة طبيعية',
          diagnosisText:
              'معدل رطوبة الهواء النسبية ($currentValue$unit) متوازن وملائم لمرحلة النمو الحالية ويحد من تكاثر الفطريات الورقية.',
          recommendedAction:
              'الحفاظ على مستوى التهوية الحالي بين المدرجات ومتابعة القراءات الدورية.',
          chartFooterStatus: 'رطوبة متوازنة ومعتدلة',
        );
      case 'temp':
      default:
        return SensorRuleEvaluation(
          state: 'normal',
          badgeText: 'ضمن النطاق الموصى به ($rangeStr)',
          directionLabel: 'ضمن المعدل الطبيعي ($currentValue$unit)',
          recommendationTitle: 'توصية زراعية لحظية — حالة طبيعية',
          diagnosisText:
              'درجات الحرارة الحالية ($currentValue$unit) مثالية لامتصاص المغذيات في حقل البن الجنوبي وتقع ضمن النطاق الموصى به ($rangeStr).',
          recommendedAction:
              'الالتزام بجدول التسميد الورقي المجدول في تمام الساعة 04:00 عصراً.',
          chartFooterStatus: 'استقرار حراري ملائم',
        );
    }
  }
}
