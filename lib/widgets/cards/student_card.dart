import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/responsive_utils.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;

  const StudentCard({
    super.key,
    required this.student,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.responsiveValue(context, 8.0, 12.0, 16.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveUtils.responsiveValue(context, 12.0, 16.0, 20.0),
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: ResponsiveUtils.responsiveValue(context, 48.0, 56.0, 64.0),
                height: ResponsiveUtils.responsiveValue(context, 48.0, 56.0, 64.0),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: ResponsiveUtils.responsiveValue(context, 24.0, 28.0, 32.0),
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),

              // Student Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: AppTextStyles.titleLarge(context)!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Roll No: ${student.rollNumber}',
                      style: AppTextStyles.bodyMedium(context)!.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (student.fatherName != null && student.fatherName!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Father: ${student.fatherName!}',
                        style: AppTextStyles.bodyMedium(context)!.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (student.phoneNumber != null && student.phoneNumber!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Phone: ${student.phoneNumber!}',
                        style: AppTextStyles.bodyMedium(context)!.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              Icon(
                Icons.arrow_forward_ios,
                size: ResponsiveUtils.responsiveValue(context, 16.0, 18.0, 20.0),
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}