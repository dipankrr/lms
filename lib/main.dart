// main.dart
import 'package:flutter/material.dart';
import 'package:lms/screens/add_student_screen.dart';
import 'package:lms/screens/classes_screen.dart';
import 'package:lms/screens/students_screen.dart';
import 'package:provider/provider.dart';
import 'package:lms/controllers/auth_controller.dart';
import 'package:lms/screens/login_screen.dart';
import 'package:lms/screens/dashboard_screen.dart';
import 'controllers/student_controller.dart';
import 'package:lms/services/supabase_service.dart';

// Update main.dart with all routes


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Supabase before runApp()
  await SupabaseService().initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => StudentController()),
        // Add other controllers here
      ],
      child: MaterialApp(
        title: 'Student Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: Consumer<AuthController>(
          builder: (context, auth, child) {
            return auth.isLoggedIn ? DashboardScreen() : LoginScreen();
          },
        ),
        routes: {
          '/dashboard': (context) => DashboardScreen(),
          '/students': (context) => StudentsScreen(),
          '/add-student': (context) => AddStudentScreen(),
          '/classes': (context) => ClassesScreen(),
          //'/subjects': (context) => SubjectsScreen(),
          //'/marks': (context) => MarksScreen(),
          //'/id-cards': (context) => IdCardScreen(),
          //'/admit-cards': (context) => AdmitCardScreen(),
          //'/results': (context) => ResultsScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}