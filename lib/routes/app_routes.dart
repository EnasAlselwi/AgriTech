/// Named route constants for all 15 approved Google Stitch screens.
abstract final class AppRoutes {
  // Authentication Screens (No Bottom Navigation Bar)
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main Application Screens (With 5-Tab Bottom Navigation Bar)
  static const String home = '/home';
  static const String monitoring = '/monitoring';
  static const String sensorDetails = '/sensor-details';
  static const String diagnosis = '/diagnosis';
  static const String diagnosisResult = '/diagnosis-result';
  static const String diagnosisHistory = '/diagnosis-history';
  static const String recommendations = '/recommendations';
  static const String myFarms = '/my-farms';
  static const String myProducts = '/my-products';
  static const String myAccount = '/my-account';

  // Settings Screens (No Bottom Navigation Bar)
  static const String settings = '/settings';
  static const String generalSettings = '/general-settings';
}
