import 'package:flutter/material.dart';
import 'package:lms/providers/student_provider.dart';
import 'package:lms/screens/auth/login_screen.dart';
import 'package:lms/screens/dashboard/dashboard_screen.dart';
import 'package:lms/services/supabase_service.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_text_styles.dart';
import 'core/utils/responsive_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const StudentManagementApp());
}

class StudentManagementApp extends StatelessWidget {
  const StudentManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StudentProvider()),
      ],
      child: MaterialApp(
        title: 'Student Management System',
        theme: _buildTheme(),
        debugShowCheckedModeBanner: false,
        home: const DashboardScreen(),
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}

// Temporary placeholder screen until we build LoginScreen
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management System'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'App Setup Complete!',
              style: AppTextStyles.headlineLarge(context),
            ),
            const SizedBox(height: 20),
            Text(
              'Ready to build Login Screen',
              style: AppTextStyles.bodyMedium(context),
            ),
          ],
        ),
      ),
    );
  }
}