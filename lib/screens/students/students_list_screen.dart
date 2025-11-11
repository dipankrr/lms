import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/adaptive_button.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/responsive_dropdown.dart';
import '../../widgets/cards/student_card.dart';
import '../../providers/student_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/responsive_utils.dart';

class StudentsListScreen extends StatefulWidget {
  const StudentsListScreen({super.key});

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    await provider.loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background2,
      appBar: const CustomAppBar(title: 'Students Management'),
      body: Consumer<StudentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.students.isEmpty) {
            return const LoadingIndicator(message: 'Loading students...');
          }

          if (provider.error != null) {
            return _buildErrorState(provider);
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(
              ResponsiveUtils.responsiveValue(context, 16.0, 20.0, 24.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filters Section
                _buildFiltersSection(context, provider),
                const SizedBox(height: 20),

                // Actions Section
                _buildActionsSection(context),
                const SizedBox(height: 20),

                // Students List
                _buildStudentsList(context, provider),
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _buildFiltersSection(BuildContext context, StudentProvider provider) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveUtils.responsiveValue(context, 12.0, 16.0, 20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Students',
              style: AppTextStyles.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Filters Row (adaptive)
            Wrap(
              spacing: 16, // horizontal space
              runSpacing: 16, // vertical space when wrapping
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Academic Year Filter
                SizedBox(
                  //height: 5,
                  width: ResponsiveUtils.isMobile(context) ? double.infinity : 220,
                  child: ResponsiveDropdown<String?>(
                    //label: 'Academic Year',
                    value: provider.selectedAcademicYearId,
                    items: provider.academicYears.map((year) {
                      return DropdownMenuItem<String?>(
                        value: year.id,
                        child:
                        Text('${year.year} ${year.isActive ? '(Active)' : ''}'),
                      );
                    }).toList(),
                    onChanged: provider.setAcademicYearFilter,
                    hint: 'Select Academic Year',
                  ),
                ),

                // Class Filter
                SizedBox(
                  width: ResponsiveUtils.isMobile(context) ? double.infinity : 220,
                  child: ResponsiveDropdown<String?>(
                    //label: 'Class',
                    value: provider.selectedClassId,
                    items: provider.classes.map((classItem) {
                      return DropdownMenuItem<String?>(
                        value: classItem.id,
                        child: Text(classItem.name),
                      );
                    }).toList(),
                    onChanged: provider.setClassFilter,
                    hint: 'Select Class',
                  ),
                ),

                // Section Filter (only shown when class is selected)
                if (provider.selectedClassId != null)
                  SizedBox(
                    width: ResponsiveUtils.isMobile(context)
                        ? double.infinity
                        : 220,
                    child: ResponsiveDropdown<String?>(
                      //label: 'Section',
                      value: provider.selectedSectionId,
                      items: provider.sectionsForSelectedClass.map((section) {
                        return DropdownMenuItem<String?>(
                          value: section.id,
                          child: Text(section.name),
                        );
                      }).toList(),
                      onChanged: provider.setSectionFilter,
                      hint: 'Select Section',
                    ),
                  ),

                // Clear Filters Button (appears inline if filters are active)
                if (provider.selectedAcademicYearId != null ||
                    provider.selectedClassId != null ||
                    provider.selectedSectionId != null)
                  SizedBox(
                    width: ResponsiveUtils.isMobile(context)
                        ? double.infinity
                        : 160, // smaller fixed width for desktop
                    child: AdaptiveButton(
                      onPressed: provider.clearFilters,
                      text: 'Clear Filters',
                      isOutlined: false,
                      textColor: Colors.red,
                      backgroundColor: Colors.red[100],
                      fullWidth: ResponsiveUtils.isMobile(context),

                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );


  }

  Widget _buildActionsSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Students',
            style: AppTextStyles.headlineMedium(context),
          ),
        ),
        AdaptiveButton(
          onPressed: () {
            // TODO: Navigate to Add Student Screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Add Student - Coming Soon!'),
                backgroundColor: AppColors.primary,
              ),
            );
          },
          text: 'Add Student',
        ),
      ],
    );
  }

  Widget _buildStudentsList(BuildContext context, StudentProvider provider) {
    final students = provider.filteredStudents;

    if (students.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                provider.selectedAcademicYearId != null ||
                    provider.selectedClassId != null ||
                    provider.selectedSectionId != null
                    ? 'No students match your filters'
                    : 'No students found',
                style: AppTextStyles.bodyLarge(context)!.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              if (provider.selectedAcademicYearId != null ||
                  provider.selectedClassId != null ||
                  provider.selectedSectionId != null)
                AdaptiveButton(
                  onPressed: provider.clearFilters,
                  text: 'Clear Filters',
                  isOutlined: true,
                ),
            ],
          ),
        ),
      );
    }

    // make it non-scrollable inside the main scroll view
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return StudentCard(
          student: student,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Edit ${student.name} - Coming Soon!'),
                backgroundColor: AppColors.primary,
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildErrorState(StudentProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error Loading Data',
            style: AppTextStyles.headlineMedium(context)!.copyWith(
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            provider.error!,
            style: AppTextStyles.bodyMedium(context)!.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          AdaptiveButton(
            onPressed: _loadData,
            text: 'Retry',
          ),
        ],
      ),
    );
  }
}