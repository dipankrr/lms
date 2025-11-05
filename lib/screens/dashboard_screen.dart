





// screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../widgets/shared/responsive_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final crossAxisCount = _getCrossAxisCount(width);

                  return GridView.builder(
                    itemCount: 6,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final cardWidth = (width - (crossAxisCount - 1) * 16) / crossAxisCount;
                      final scale = _calculateScale(cardWidth);

                      // Sample card data
                      final data = [
                        {'title': 'Total Students', 'value': '156', 'icon': Icons.people, 'color': Colors.blue, 'route': '/students'},
                        {'title': 'Classes', 'value': '8', 'icon': Icons.class_, 'color': Colors.green, 'route': '/classes'},
                        {'title': 'Subjects', 'value': '20', 'icon': Icons.subject, 'color': Colors.orange, 'route': '/subjects'},
                        {'title': 'ID Cards', 'value': 'Generate', 'icon': Icons.badge, 'color': Colors.purple, 'route': '/id-cards'},
                        {'title': 'Admit Cards', 'value': 'Generate', 'icon': Icons.assignment, 'color': Colors.red, 'route': '/admit-cards'},
                        {'title': 'Enter Marks', 'value': 'Term 1', 'icon': Icons.grade, 'color': Colors.teal, 'route': '/marks'},
                      ];

                      final item = data[index];

                      return _StatCard(
                        title: item['title'] as String,
                        value: item['value'] as String,
                        icon: item['icon'] as IconData,
                        color: item['color'] as Color,
                        onTap: () => Navigator.pushNamed(context, item['route'] as String),
                        scale: scale,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1400) return 4;
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 2; // <-- min 2
  }

  double _calculateScale(double cardWidth) {
    // Scale based on card width, clamp between 0.7 and 1.0
    double scale = cardWidth / 300; // assuming 300px as "base" card width
    if (scale < 0.7) scale = 0.7;
    if (scale > 1.0) scale = 1.0;
    return scale;
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double scale;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12 * scale)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12 * scale),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(20 * scale),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(14 * scale),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 40 * scale),
              ),
              SizedBox(height: 14 * scale),
              Text(
                value,
                style: TextStyle(fontSize: 26 * scale, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6 * scale),
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 16 * scale),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*
// screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../widgets/shared/responsive_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final crossAxisCount = _getCrossAxisCount(width);
                  final scale = _calculateScale(width);

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16 * scale,
                    mainAxisSpacing: 16 * scale,
                    children: [
                      _StatCard(
                        title: 'Total Students',
                        value: '156',
                        icon: Icons.people,
                        color: Colors.blue,
                        onTap: () => Navigator.pushNamed(context, '/students'),
                        scale: scale,
                      ),
                      _StatCard(
                        title: 'Classes',
                        value: '8',
                        icon: Icons.class_,
                        color: Colors.green,
                        onTap: () => Navigator.pushNamed(context, '/classes'),
                        scale: scale,
                      ),
                      _StatCard(
                        title: 'Subjects',
                        value: '20',
                        icon: Icons.subject,
                        color: Colors.orange,
                        onTap: () => Navigator.pushNamed(context, '/subjects'),
                        scale: scale,
                      ),
                      _StatCard(
                        title: 'ID Cards',
                        value: 'Generate',
                        icon: Icons.badge,
                        color: Colors.purple,
                        onTap: () => Navigator.pushNamed(context, '/id-cards'),
                        scale: scale,
                      ),
                      _StatCard(
                        title: 'Admit Cards',
                        value: 'Generate',
                        icon: Icons.assignment,
                        color: Colors.red,
                        onTap: () => Navigator.pushNamed(context, '/admit-cards'),
                        scale: scale,
                      ),
                      _StatCard(
                        title: 'Enter Marks',
                        value: 'Term 1',
                        icon: Icons.grade,
                        color: Colors.teal,
                        onTap: () => Navigator.pushNamed(context, '/marks'),
                        scale: scale,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1400) return 4; // large desktop
    if (width >= 1200) return 4; // desktop (keep 4 for nice look)
    if (width >= 900) return 3;  // smaller desktop
    if (width >= 600) return 2;  // tablet
    return 1;                    // mobile
  }

  double _calculateScale(double width) {
    if (width >= 1400) return 1.0;
    if (width >= 1200) return 0.95;
    if (width >= 1000) return 0.9;
    if (width >= 800) return 0.85;
    if (width >= 600) return 0.8;
    return 0.75;
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double scale;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(20 * scale),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(14 * scale),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 40 * scale),
              ),
              SizedBox(height: 14 * scale),
              Text(
                value,
                style: TextStyle(fontSize: 26 * scale, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6 * scale),
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 16 * scale),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


 */

