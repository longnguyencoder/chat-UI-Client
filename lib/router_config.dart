import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilev2/views/auth/forgot_password_view.dart';
import 'package:mobilev2/views/auth/login_view.dart';
import 'package:mobilev2/views/auth/otp_forgotpass_view.dart';
import 'package:mobilev2/views/auth/register_view.dart';
import 'package:mobilev2/views/auth/reset_password_view.dart';
import 'package:mobilev2/views/auth/verify_otp_view.dart';
import 'package:mobilev2/views/home/health_profile_view.dart';
import 'package:mobilev2/views/home/main_view.dart';
import 'package:mobilev2/views/home/setting_view.dart';
import 'package:mobilev2/views/medication/add_medication_view.dart';
import 'package:mobilev2/views/medication/medication_detail_view.dart';
import 'package:mobilev2/views/medication/medication_list_view.dart';
import 'package:mobilev2/views/medical/medical_report_analysis_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Router configuration for the application
/// Handles all navigation and deep linking
class AppRouter {
  static Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/login',
      redirect: (BuildContext context, GoRouterState state) async {
        final isLoggedIn = await _isLoggedIn();
        final isAuthRoute = state.matchedLocation.startsWith('/login') ||
            state.matchedLocation.startsWith('/register') ||
            state.matchedLocation.startsWith('/verify_otp') ||
            state.matchedLocation.startsWith('/forgot_password') ||
            state.matchedLocation.startsWith('/reset_password');

        // If not logged in and trying to access protected route
        if (!isLoggedIn && !isAuthRoute) {
          return '/login';
        }

        // If logged in and trying to access auth route
        if (isLoggedIn && isAuthRoute) {
          return '/home';
        }

        // No redirect needed
        return null;
      },
      routes: [
        // Authentication Routes
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginView(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterView(),
        ),
        GoRoute(
          path: '/verify_otp',
          name: 'verify_otp',
          builder: (context, state) => const VerifyOtpView(),
        ),
        GoRoute(
          path: '/verify_otp_forgot_pass',
          name: 'verify_otp_forgot_pass',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>?;
            final email = extras?['email'] ?? '';
            return VerifyOtpForgotPassView(email: email);
          },
        ),
        GoRoute(
          path: '/forgot_password',
          name: 'forgot_password',
          builder: (context, state) => const ForgotPasswordView(),
        ),
        GoRoute(
          path: '/reset_password',
          name: 'reset_password',
          builder: (context, state) {
            final email = state.uri.queryParameters['email'] ?? '';
            final otp = state.uri.queryParameters['otp'] ?? '';
            return ResetPasswordView(email: email, otp: otp);
          },
        ),

        // Main App Routes
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const MainView(),
        ),
        GoRoute(
          path: '/chat/:conversationId',
          name: 'chat',
          builder: (context, state) {
            final conversationId = int.tryParse(state.pathParameters['conversationId'] ?? '');
            return MainView(conversationId: conversationId);
          },
        ),

        // Settings
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingView(),
        ),

        // Health Profile
        GoRoute(
          path: '/health-profile',
          name: 'health_profile',
          builder: (context, state) => const HealthProfileView(),
        ),

        // Medication Routes
        GoRoute(
          path: '/medications',
          name: 'medications',
          builder: (context, state) => const MedicationListView(),
          routes: [
            GoRoute(
              path: 'add',
              name: 'add_medication',
              builder: (context, state) => const AddMedicationView(),
            ),
            // Note: medication detail view uses Navigator.push
            // because it requires passing complex objects (schedule, viewModel)
          ],
        ),
        
        GoRoute(
          path: '/medical-report-analysis',
          name: 'medical_report_analysis',
          builder: (context, state) => const MedicalReportAnalysisView(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found: ${state.matchedLocation}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
