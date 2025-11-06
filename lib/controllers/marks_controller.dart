// controllers/marks_controller.dart
import 'package:flutter/foundation.dart';
import 'package:lms/models/marks.dart';
import 'package:lms/services/marks_service.dart';
import 'package:lms/services/student_service.dart';
import 'package:lms/services/subject_service.dart';

import '../models/student.dart';

class MarksController with ChangeNotifier {
  final MarksService _marksService = MarksService();
  final StudentService _studentService = StudentService();
  final SubjectService _subjectService = SubjectService();

  List<StudentMarks> _studentMarks = [];
  bool _isLoading = false;
  String? _error;
  bool _hasUnsavedChanges = false;

  List<StudentMarks> get studentMarks => _studentMarks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUnsavedChanges => _hasUnsavedChanges;

  // Load students for marks entry (even if no marks exist yet)
  Future<void> loadStudentsForMarks({
    required String classId,
    String? sectionId,
    required int year,
    required int term,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Get students for the class/section
      final students = await _studentService.getStudents(
        classId: classId,
        sectionId: sectionId,
        academicYear: year,
      );

      // 2. Get all subjects
      final subjects = await _subjectService.getSubjects();

      // 3. Get existing marks for this term (if any)
      final existingMarks = await _marksService.getExistingMarks(
        studentIds: students.map((s) => s.id).toList(),
        term: term,
        academicYear: year,
      );

      // 4. Create StudentMarks objects
      _studentMarks = students.map((student) {
        final subjectMarks = <String, MarkEntry>{};

        for (var subject in subjects) {
          // Find existing marks for this student and subject
          final existingMark = existingMarks.firstWhere(
                (mark) => mark['student_id'] == student.id &&
                mark['subject_id'] == subject.id,
            orElse: () => {},
          );

          subjectMarks[subject.id] = MarkEntry(
            marksObtained: existingMark['marks_obtained']?.toDouble(),
            isAbsent: existingMark['is_absent'] ?? false,
            subjectName: subject.name,
            totalMarks: subject.totalMarks,
            passMarks: subject.passMarks,
          );
        }

        return StudentMarks(
          studentId: student.id,
          studentName: student.fullName,
          rollNumber: student.rollNumber,
          section: _getSectionName(student), // TODO: Get actual section name
          subjectMarks: subjectMarks,
        );
      }).toList();

      _hasUnsavedChanges = false;
    } catch (e) {
      _error = 'Failed to load students: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update individual mark
  void updateMark({
    required String studentId,
    required String subjectId,
    required double? marks,
    required bool isAbsent,
  }) {
    final studentIndex = _studentMarks.indexWhere((s) => s.studentId == studentId);
    if (studentIndex != -1) {
      final student = _studentMarks[studentIndex];
      if (student.subjectMarks.containsKey(subjectId)) {
        student.subjectMarks[subjectId] = MarkEntry(
          marksObtained: isAbsent ? null : marks,
          isAbsent: isAbsent,
          subjectName: student.subjectMarks[subjectId]!.subjectName,
          totalMarks: student.subjectMarks[subjectId]!.totalMarks,
          passMarks: student.subjectMarks[subjectId]!.passMarks,
        );
        _hasUnsavedChanges = true;
        notifyListeners();
      }
    }
  }

  // Save all marks for current term
  Future<void> saveAllMarks(int term) async {
    if (!_hasUnsavedChanges) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _marksService.saveAllMarks(_studentMarks, term);
      _hasUnsavedChanges = false;
    } catch (e) {
      _error = 'Failed to save marks: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Helper method to get section name
  String _getSectionName(Student student) {
    // TODO: Implement actual section name lookup
    return 'Section A';
  }
}