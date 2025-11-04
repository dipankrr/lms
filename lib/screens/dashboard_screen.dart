// screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:lms/widgets/shared/sidebar.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Sidebar(),
          // Main Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 32),
                  // Stats Grid
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: _getCrossAxisCount(context),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _StatCard(
                        title: 'Total Students',
                        value: '156',
                        icon: Icons.people,
                        color: Colors.blue,
                        onTap: () => Navigator.pushNamed(context, '/students'),
                      ),
                      _StatCard(
                        title: 'Classes',
                        value: '8',
                        icon: Icons.class_,
                        color: Colors.green,
                        onTap: () => Navigator.pushNamed(context, '/classes'),
                      ),
                      _StatCard(
                        title: 'Subjects',
                        value: '20',
                        icon: Icons.subject,
                        color: Colors.orange,
                        onTap: () => Navigator.pushNamed(context, '/subjects'),
                      ),
                      _StatCard(
                        title: 'ID Cards',
                        value: 'Generate',
                        icon: Icons.badge,
                        color: Colors.purple,
                        onTap: () => Navigator.pushNamed(context, '/id-cards'),
                      ),
                      _StatCard(
                        title: 'Admit Cards',
                        value: 'Generate',
                        icon: Icons.assignment,
                        color: Colors.red,
                        onTap: () => Navigator.pushNamed(context, '/admit-cards'),
                      ),
                      _StatCard(
                        title: 'Enter Marks',
                        value: 'Term 1',
                        icon: Icons.grade,
                        color: Colors.teal,
                        onTap: () => Navigator.pushNamed(context, '/marks'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    if (MediaQuery.of(context).size.width > 1200) return 4;
    if (MediaQuery.of(context).size.width > 800) return 3;
    if (MediaQuery.of(context).size.width > 600) return 2;
    return 1;
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              SizedBox(height: 16),
              Text(
                value,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}