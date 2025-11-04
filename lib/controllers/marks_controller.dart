// controllers/marks_controller.dart
import 'package:flutter/foundation.dart';
import 'package:lms/models/marks.dart';
import 'package:lms/services/marks_service.dart';

class MarksController with ChangeNotifier {
  final MarksService _marksService = MarksService();

  List<StudentMarks> _studentMarks = [];
  bool _isLoading = false;
  String? _error;
  bool _hasUnsavedChanges = false;

  List<StudentMarks> get studentMarks => _studentMarks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUnsavedChanges => _hasUnsavedChanges;

  Future<void> loadMarks({
    required String classId,
    String? sectionId,
    required int term,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _studentMarks = await _marksService.getMarksForClass(
        classId: classId,
        sectionId: sectionId,
        term: term,
        academicYear: 2026,
      );
      _hasUnsavedChanges = false;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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
          marksObtained: marks,
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

  Future<void> saveAllMarks(int term) async {
    if (!_hasUnsavedChanges) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _marksService.saveAllMarks(_studentMarks, term);
      _hasUnsavedChanges = false;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void markAsSaved() {
    _hasUnsavedChanges = false;
    notifyListeners();
  }
}