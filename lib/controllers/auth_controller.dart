// controllers/auth_controller.dart
import 'package:flutter/foundation.dart';

class AuthController with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login(String username, String password) {
    if (username == "admin" && password == "admin123") {
      _isLoggedIn = true;
      notifyListeners();
    } else {
      throw Exception("Invalid credentials");
    }
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

// screens/dashboard_screen.dart
// class DashboardScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveLayout(
//       sidebar: Sidebar(), // Your existing sidebar
//       content: Padding(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Your existing dashboard content...
//             Text('Dashboard', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
//             SizedBox(height: 32),
//             // Stats grid...
//           ],
//         ),
//       ),
//     );
//   }
// }