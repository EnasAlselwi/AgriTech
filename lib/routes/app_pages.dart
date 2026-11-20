import 'package:flutter/material.dart';

import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/diagnosis/presentation/pages/diagnosis_history_page.dart';
import '../features/diagnosis/presentation/pages/diagnosis_page.dart';
import '../features/diagnosis/presentation/pages/diagnosis_result_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/home/presentation/pages/my_farms_page.dart';
import '../features/home/presentation/pages/my_products_page.dart';
import '../features/monitoring/presentation/pages/monitoring_page.dart';
import '../features/monitoring/presentation/pages/recommendations_page.dart';
import '../features/monitoring/presentation/pages/sensor_details_page.dart';
import '../features/profile/presentation/pages/general_settings_page.dart';
import '../features/profile/presentation/pages/my_account_page.dart';
import '../features/profile/presentation/pages/settings_page.dart';
import 'app_routes.dart';

/// Route table mapping all 15 approved Google Stitch screens.
abstract final class AppPages {
  static Map<String, WidgetBuilder> get routes => {
    // 1–3. Authentication Screens (No Bottom Navigation)
    AppRoutes.login: (context) => const LoginPage(),
    AppRoutes.register: (context) => const RegisterPage(),
    AppRoutes.forgotPassword: (context) => const ForgotPasswordPage(),

    // 4–13. Authenticated Internal Screens (With 5-Tab Bottom Navigation)
    AppRoutes.home: (context) => const HomePage(),
    AppRoutes.monitoring: (context) => const MonitoringPage(),
    AppRoutes.sensorDetails: (context) => const SensorDetailsPage(),
    AppRoutes.diagnosis: (context) => const DiagnosisPage(),
    AppRoutes.diagnosisResult: (context) => const DiagnosisResultPage(),
    AppRoutes.diagnosisHistory: (context) => const DiagnosisHistoryPage(),
    AppRoutes.recommendations: (context) => const RecommendationsPage(),
    AppRoutes.myFarms: (context) => const MyFarmsPage(),
    AppRoutes.myProducts: (context) => const MyProductsPage(),
    AppRoutes.myAccount: (context) => const MyAccountPage(),

    // 14–15. Settings & General Settings Screens (No Bottom Navigation)
    AppRoutes.settings: (context) => const SettingsPage(),
    AppRoutes.generalSettings: (context) => const GeneralSettingsPage(),
  };
}
