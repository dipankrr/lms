// widgets/shared/sidebar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lms/controllers/auth_controller.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: Colors.blue[800],
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(24),
            color: Colors.blue[900],
            child: Row(
              children: [
                Icon(Icons.school, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Text(
                  'Student Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _NavItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  route: '/dashboard',
                ),
                _NavItem(
                  icon: Icons.people,
                  title: 'Students',
                  route: '/students',
                ),
                _NavItem(
                  icon: Icons.class_,
                  title: 'Classes & Sections',
                  route: '/classes',
                ),
                _NavItem(
                  icon: Icons.subject,
                  title: 'Subjects',
                  route: '/subjects',
                ),
                _NavItem(
                  icon: Icons.grade,
                  title: 'Enter Marks',
                  route: '/marks',
                ),
                _NavItem(
                  icon: Icons.assignment,
                  title: 'Results',
                  route: '/results',
                ),
                _NavItem(
                  icon: Icons.badge,
                  title: 'ID Cards',
                  route: '/id-cards',
                ),
                _NavItem(
                  icon: Icons.assignment_ind,
                  title: 'Admit Cards',
                  route: '/admit-cards',
                ),
                Divider(color: Colors.white54, height: 32),
                _NavItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  route: '/settings',
                ),
                _NavItem(
                  icon: Icons.school,
                  title: 'School Details',
                  route: '/school-details',
                ),
              ],
            ),
          ),
          // Logout Button
          Container(
            padding: EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                Provider.of<AuthController>(context, listen: false).logout();
              },
              icon: Icon(Icons.logout, size: 20),
              label: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const _NavItem({
    required this.icon,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      hoverColor: Colors.blue[700],
    );
  }
}