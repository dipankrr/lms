import 'package:flutter/material.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/adaptive_button.dart';
import '../../widgets/cards/stats_card.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/responsive_utils.dart';
import '../students/students_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background2,
      appBar: const CustomAppBar(
        title: 'Dashboard',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          ResponsiveUtils.responsiveValue(context, 16.0, 20.0, 24.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(context),
            const SizedBox(height: 32),

            // Stats Cards
            _buildStatsSection(context),
            const SizedBox(height: 32),

            // Quick Actions
            _buildQuickActionsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, Admin!',
          style: AppTextStyles.headlineLarge(context),
        ),
        const SizedBox(height: 8),
        Text(
          'Student Management System',
          style: AppTextStyles.bodyMedium(context)!.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final crossAxisCount = ResponsiveUtils.responsiveValue(context, 2, 3, 5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: AppTextStyles.titleLarge(context),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: crossAxisCount as int,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true, // important for scrollable parent
          physics: const NeverScrollableScrollPhysics(), // disable inner scroll
          childAspectRatio: 1.5,
          children: const [
            StatsCard(
              title: 'Total Students',
              value: '0',
              icon: Icons.people,
            ),
            StatsCard(
              title: 'Active Classes',
              value: '0',
              icon: Icons.class_,
            ),
            StatsCard(
              title: 'Subjects',
              value: '0',
              icon: Icons.subject,
            ),
            StatsCard(
              title: 'Academic Years',
              value: '0',
              icon: Icons.calendar_today,
            ),
            StatsCard(
              title: 'Academic Years',
              value: '0',
              icon: Icons.calendar_today,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    final crossAxisCount = ResponsiveUtils.responsiveValue(context, 2, 3, 4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.titleLarge(context),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: crossAxisCount as int,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          shrinkWrap: true, // allow scrollable parent
          physics: const NeverScrollableScrollPhysics(), // handled by parent
          children: [
            _buildActionCard(
              context,
              'Students',
              Icons.people_outline,
              Colors.blue,
                  () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const StudentsListScreen(),
                ),
              ),
            ),
            _buildActionCard(
              context,
              'Marks',
              Icons.assignment,
              Colors.green,
                  () => _navigateTo(context, 'marks'),
            ),
            _buildActionCard(
              context,
              'ID Cards',
              Icons.badge,
              Colors.orange,
                  () => _navigateTo(context, 'id_cards'),
            ),
            _buildActionCard(
              context,
              'Results',
              Icons.assessment,
              Colors.purple,
                  () => _navigateTo(context, 'results'),
            ),
            _buildActionCard(
              context,
              'Academic Years',
              Icons.calendar_month,
              Colors.red,
                  () => _navigateTo(context, 'academic_years'),
            ),
            _buildActionCard(
              context,
              'Classes & Sections',
              Icons.school,
              Colors.teal,
                  () => _navigateTo(context, 'classes'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: ResponsiveUtils.responsiveValue(context, 32.0, 36.0, 40.0),
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.bodyMedium(context)!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    // TODO: Implement navigation to actual screens
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to $route - Coming Soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
