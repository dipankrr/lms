// screens/marks_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lms/controllers/marks_controller.dart';
import 'package:lms/widgets/shared/filter_bar.dart';
import 'package:lms/widgets/marks/marks_table.dart';
import 'package:lms/widgets/shared/custom_button.dart';

class MarksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Marks'),
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _MarksContent(),
    );
  }
}

class _MarksContent extends StatefulWidget {
  @override
  __MarksContentState createState() => __MarksContentState();
}

class __MarksContentState extends State<_MarksContent> {
  final Map<String, dynamic> _currentFilters = {};

  @override
  void initState() {
    super.initState();
    // Set default filters
    _currentFilters['year'] = 2026;
    _currentFilters['term'] = 1;
  }

  void _onFilterChanged(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters.clear();
      _currentFilters.addAll(filters);
    });

    // Load students immediately when class is selected
    if (filters['classId'] != null) {
      final controller = Provider.of<MarksController>(context, listen: false);
      controller.loadStudentsForMarks(
        classId: filters['classId'],
        sectionId: filters['sectionId'],
        year: filters['year'] ?? 2026,
        term: filters['term'] ?? 1,
      );
    }
  }

  Future<void> _saveAllMarks() async {
    final controller = Provider.of<MarksController>(context, listen: false);
    await controller.saveAllMarks(_currentFilters['term'] ?? 1);

    if (controller.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Marks saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _HeaderSection(onSave: _saveAllMarks),
          SizedBox(height: 24),
          FilterBar(
            onFilterChanged: _onFilterChanged,
            initialFilters: _currentFilters,
          ),
          SizedBox(height: 24),
          Expanded(child: _MarksTableSection(filters: _currentFilters)),
          _SaveStatusSection(),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final VoidCallback onSave;

  const _HeaderSection({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Enter Marks',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Consumer<MarksController>(
          builder: (context, controller, child) {
            return CustomButton(
              text: 'Save All Marks',
              onPressed: controller.hasUnsavedChanges ? onSave : null,
              isLoading: controller.isLoading,
              icon: Icons.save,
            );
          },
        ),
      ],
    );
  }
}

class _MarksTableSection extends StatelessWidget {
  final Map<String, dynamic> filters;

  const _MarksTableSection({required this.filters});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarksController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.error != null) {
          return _ErrorSection(error: controller.error!);
        }

        if (filters['classId'] == null) {
          return _EmptyState(
            icon: Icons.filter_list,
            message: 'Select class to view students',
          );
        }

        if (controller.studentMarks.isEmpty) {
          return _EmptyState(
            icon: Icons.people_outline,
            message: 'No students found for selected class',
          );
        }

        return MarksTable(
          studentMarks: controller.studentMarks,
          onMarksUpdated: (studentId, subjectId, marks, isAbsent) {
            controller.updateMark(
              studentId: studentId,
              subjectId: subjectId,
              marks: marks,
              isAbsent: isAbsent,
            );
          },
        );
      },
    );
  }
}

class _ErrorSection extends StatelessWidget {
  final String error;

  const _ErrorSection({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text('Error: $error', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(message, style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _SaveStatusSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MarksController>(
      builder: (context, controller, child) {
        if (!controller.hasUnsavedChanges) return SizedBox();

        return Container(
          padding: EdgeInsets.all(16),
          color: Colors.orange[50],
          child: Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange),
              SizedBox(width: 8),
              Text('You have unsaved changes', style: TextStyle(color: Colors.orange[800])),
            ],
          ),
        );
      },
    );
  }
}