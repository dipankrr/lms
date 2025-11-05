// widgets/shared/sidebar.dart
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback? onItemTap;

  const Sidebar({
    required this.isCollapsed,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCollapsed ? 70 : 250,
      color: Colors.blue[800],
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue[900],
            child: Row(
              children: [
                if (!isCollapsed) ...[
                  Icon(Icons.school, color: Colors.white, size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Student Management',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ] else ...[
                  Icon(Icons.school, color: Colors.white, size: 32),
                ],
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _NavItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  route: '/dashboard',
                  isCollapsed: isCollapsed,
                  onTap: onItemTap,
                ),
                _NavItem(
                  icon: Icons.people,
                  title: 'Students',
                  route: '/students',
                  isCollapsed: isCollapsed,
                  onTap: onItemTap,
                ),
                _NavItem(
                  icon: Icons.class_,
                  title: 'Classes',
                  route: '/classes',
                  isCollapsed: isCollapsed,
                  onTap: onItemTap,
                ),
                _NavItem(
                  icon: Icons.subject,
                  title: 'Subjects',
                  route: '/subjects',
                  isCollapsed: isCollapsed,
                  onTap: onItemTap,
                ),
                _NavItem(
                  icon: Icons.grade,
                  title: 'Marks',
                  route: '/marks',
                  isCollapsed: isCollapsed,
                  onTap: onItemTap,
                ),
                _NavItem(
                  icon: Icons.assignment,
                  title: 'Results',
                  route: '/results',
                  isCollapsed: isCollapsed,
                  onTap: onItemTap,
                ),
                _NavItem(
                  icon: Icons.badge,
                  title: 'ID Cards',
                  route: '/id-cards',
                  isCollapsed: isCollapsed,
                  onTap: onItemTap,
                ),
                _NavItem(
                  icon: Icons.assignment_ind,
                  title: 'Admit Cards',
                  route: '/admit-cards',
                  isCollapsed: isCollapsed,
                  onTap: onItemTap,
                ),
                Divider(color: Colors.white54, height: 32),
                _NavItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  route: '/settings',
                  isCollapsed: isCollapsed,
                  onTap: onItemTap,
                ),
                _NavItem(
                  icon: Icons.school,
                  title: 'School Details',
                  route: '/school-details',
                  isCollapsed: isCollapsed,
                  onTap: onItemTap,
                ),
              ],
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
  final bool isCollapsed;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.title,
    required this.route,
    required this.isCollapsed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isCollapsed ? title : '',
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: isCollapsed ? null : Text(title, style: TextStyle(color: Colors.white)),
        onTap: () {
          Navigator.pushNamed(context, route);
          onTap?.call(); // Close drawer on mobile
        },
        hoverColor: Colors.blue[700],
        dense: true,
        minLeadingWidth: 0,
      ),
    );
  }
}