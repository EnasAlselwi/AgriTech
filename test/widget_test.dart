// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:agritech/core/theme/app_theme.dart';
import 'package:agritech/main.dart';
import 'package:agritech/routes/app_routes.dart';
import 'package:agritech/shared/widgets/agritech_bottom_nav.dart';
import 'package:agritech/shared/widgets/agritech_header_banner.dart';
import 'package:agritech/shared/widgets/phase1_verification_page.dart';

void main() {
  testWidgets(
    'Phase 1 visual verification screen renders and toggles Light/Dark theme',
    (WidgetTester tester) async {
      ThemeMode mode = ThemeMode.light;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: mode,
              home: Phase1VerificationPage(
                themeMode: mode,
                onToggleTheme: () {
                  setState(() {
                    mode = mode == ThemeMode.light
                        ? ThemeMode.dark
                        : ThemeMode.light;
                  });
                },
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      // Verify Cairo font weight labels and Arabic RTL text
      expect(find.text('Cairo Regular (400)'), findsOneWidget);
      expect(find.text('Cairo Medium (500)'), findsOneWidget);
      expect(find.text('Cairo SemiBold (600)'), findsOneWidget);
      expect(find.text('Cairo Bold (700)'), findsOneWidget);

      // Verify initial Light theme state
      expect(find.text('المظهر: فاتح'), findsOneWidget);

      // Toggle to Dark theme
      await tester.tap(find.byKey(const Key('theme_toggle_button')));
      await tester.pumpAndSettle();

      // Verify Dark theme state
      expect(find.text('المظهر: داكن'), findsOneWidget);
    },
  );

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: MyHomePage(title: 'Flutter Demo Home Page')),
    );

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets(
    'Phase 2 & 2.1: All 15 screens use white content scroll container and enforce bottom nav rules',
    (WidgetTester tester) async {
      final routesWithoutBottomNav = <String>[
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.forgotPassword,
        AppRoutes.settings,
        AppRoutes.generalSettings,
      ];

      for (final route in routesWithoutBottomNav) {
        await tester.pumpWidget(
          MyApp(key: ValueKey('no_nav_$route'), initialRoute: route),
        );
        await tester.pumpAndSettle();
        expect(find.byType(AgriTechBottomNav), findsNothing);
        expect(find.byType(AgriTechWhiteSheetContainer), findsOneWidget);
      }

      final routesWithBottomNav = <String>[
        AppRoutes.home,
        AppRoutes.monitoring,
        AppRoutes.sensorDetails,
        AppRoutes.diagnosis,
        AppRoutes.diagnosisResult,
        AppRoutes.diagnosisHistory,
        AppRoutes.recommendations,
        AppRoutes.myFarms,
        AppRoutes.myProducts,
        AppRoutes.myAccount,
      ];

      for (final route in routesWithBottomNav) {
        await tester.pumpWidget(
          MyApp(key: ValueKey('with_nav_$route'), initialRoute: route),
        );
        await tester.pumpAndSettle();
        expect(find.byType(AgriTechBottomNav), findsOneWidget);
        expect(find.byType(AgriTechWhiteSheetContainer), findsOneWidget);
      }
    },
  );

  testWidgets(
    'Phase 2.1: Settings & General Settings switch between Arabic (RTL) and English (LTR) and open Support, Privacy, and Terms modals',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(initialRoute: AppRoutes.settings));
      await tester.pumpAndSettle();

      // Default Arabic state
      expect(find.text('الإعدادات'), findsOneWidget);
      expect(find.text('تفضيلات التطبيق'), findsOneWidget);

      // Switch to English
      await tester.tap(find.byKey(const Key('settings_lang_en_button')));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Application Preferences'), findsOneWidget);
      expect(find.text('Support & Privacy Team'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Terms of Use'), findsOneWidget);

      // Open Support & Privacy Team modal in English
      await tester.ensureVisible(
        find.byKey(const Key('settings_support_team_button')),
      );
      await tester.tap(find.byKey(const Key('settings_support_team_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('support_modal')), findsOneWidget);

      // Submit empty form to trigger validation
      await tester.ensureVisible(
        find.byKey(const Key('support_submit_button')),
      );
      await tester.tap(find.byKey(const Key('support_submit_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('support_error_banner')), findsOneWidget);

      // Close Support modal
      await tester.tap(find.byKey(const Key('support_modal_close_button')));
      await tester.pumpAndSettle();

      // Open Privacy Policy modal & confirm with "Understood"
      await tester.ensureVisible(
        find.byKey(const Key('settings_privacy_policy_button')),
      );
      await tester.tap(find.byKey(const Key('settings_privacy_policy_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('privacy_policy_modal')), findsOneWidget);
      expect(find.text('Data Used by the Application'), findsOneWidget);
      await tester.tap(
        find.byKey(const Key('privacy_policy_modal_confirm_button')),
      );
      await tester.pumpAndSettle();

      // Open Terms of Use modal & confirm with "Understood"
      await tester.ensureVisible(
        find.byKey(const Key('settings_terms_of_use_button')),
      );
      await tester.tap(find.byKey(const Key('settings_terms_of_use_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('terms_of_use_modal')), findsOneWidget);
      expect(find.text('Application Usage'), findsOneWidget);
      await tester.tap(
        find.byKey(const Key('terms_of_use_modal_confirm_button')),
      );
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'Phase 2.1: Back navigation replaces Settings when navigating from Home to Monitoring and Sensor Details, and thresholds evaluate readings',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(initialRoute: AppRoutes.home));
      await tester.pumpAndSettle();

      // On root Home, Settings button is shown (no previous route)
      expect(find.byKey(const Key('header_settings_button')), findsOneWidget);

      // Navigate from Home to Monitoring
      await tester.ensureVisible(
        find.byKey(const Key('home_all_readings_button')),
      );
      await tester.tap(find.byKey(const Key('home_all_readings_button')));
      await tester.pumpAndSettle();

      // On Monitoring, Back button replaces Settings and updated button label is displayed
      expect(find.byKey(const Key('header_back_button')), findsOneWidget);
      expect(find.text('عرض سجل القراءات السابقة'), findsOneWidget);

      // Tap "عرض سجل القراءات السابقة" to open Sensor Details
      await tester.ensureVisible(
        find.byKey(const Key('monitoring_history_button')),
      );
      await tester.tap(find.byKey(const Key('monitoring_history_button')));
      await tester.pumpAndSettle();

      // On Sensor Details, Back button is present; test Low and High threshold simulation
      expect(find.byKey(const Key('header_back_button')), findsOneWidget);
      await tester.ensureVisible(find.byKey(const Key('sensor_sim_low')));
      await tester.tap(find.byKey(const Key('sensor_sim_low')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('sensor_current_reading_recommendation_box')),
        findsOneWidget,
      );

      // Navigate Back to Monitoring, then Back to Home
      await tester.tap(find.byKey(const Key('header_back_button')));
      await tester.pumpAndSettle();
      expect(find.text('المراقبة الزراعية'), findsOneWidget);
    },
  );

  testWidgets(
    'Phase 2.1: Product Details, Farm Details, and Diagnosis Camera/Workflow modals open and function',
    (WidgetTester tester) async {
      // 1. Product Details
      await tester.pumpWidget(
        const MyApp(
          key: ValueKey('products_test'),
          initialRoute: AppRoutes.myProducts,
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const Key('product_view_details_prod_1')),
      );
      await tester.tap(find.byKey(const Key('product_view_details_prod_1')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('product_details_modal')), findsOneWidget);
      await tester.tap(
        find.byKey(const Key('product_details_close_icon_button')),
      );
      await tester.pumpAndSettle();

      // 2. Farm Details
      await tester.pumpWidget(
        const MyApp(
          key: ValueKey('farms_test'),
          initialRoute: AppRoutes.myFarms,
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const Key('farm_view_details_farm_1')),
      );
      await tester.tap(find.byKey(const Key('farm_view_details_farm_1')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('farm_details_modal')), findsOneWidget);
      await tester.tap(find.byKey(const Key('farm_details_close_icon_button')));
      await tester.pumpAndSettle();

      // 3. Diagnosis Camera Capture & Workflow Status
      const channel = MethodChannel('com.agritech.agritech/diagnosis_media');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            switch (call.method) {
              case 'startCameraPreview':
                return <String, dynamic>{
                  'textureId': -1,
                  'previewWidth': 1280,
                  'previewHeight': 960,
                };
              case 'captureCameraPhoto':
                return <String, dynamic>{
                  'originalPath':
                      'asset:lib/assets/images/sample_leaf_rust.png',
                  'preprocessedPath':
                      'asset:lib/assets/images/sample_leaf_rust.png',
                };
              case 'stopCameraPreview':
                return true;
              case 'pickGalleryImage':
                return <String, dynamic>{
                  'originalPath':
                      'asset:lib/assets/images/sample_leaf_rust.png',
                  'preprocessedPath':
                      'asset:lib/assets/images/sample_leaf_rust.png',
                };
              default:
                return null;
            }
          });

      await tester.pumpWidget(
        const MyApp(
          key: ValueKey('diagnosis_test'),
          initialRoute: AppRoutes.diagnosis,
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const Key('diagnosis_capture_button')),
      );
      await tester.tap(find.byKey(const Key('diagnosis_capture_button')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('live_camera_capture_sheet')),
        findsOneWidget,
      );
      await tester.ensureVisible(
        find.byKey(const Key('camera_shutter_capture_button')),
      );
      await tester.tap(find.byKey(const Key('camera_shutter_capture_button')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const Key('camera_confirm_photo_button')),
      );
      await tester.tap(find.byKey(const Key('camera_confirm_photo_button')));
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const Key('start_diagnosis_button')),
      );
      await tester.tap(find.byKey(const Key('start_diagnosis_button')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('diagnosis_workflow_status_dialog')),
        findsOneWidget,
      );
    },
  );
}
