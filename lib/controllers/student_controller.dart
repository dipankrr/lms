// controllers/student_controller.dart
import 'package:flutter/foundation.dart';
import 'package:lms/models/student.dart';
import 'package:lms/services/student_service.dart';

class StudentController with ChangeNotifier {
  final StudentService _studentService = StudentService();

  List<Student> _students = [];
  bool _isLoading = false;
  String? _error;

  List<Student> get students => _students;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadStudents({String? classId, String? sectionId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _students = await _studentService.getStudents(
        classId: classId,
        sectionId: sectionId,
        academicYear: 2026,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addStudent(Student student) async {
    try {
      await _studentService.addStudent(student);
      await loadStudents(); // Reload the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  Future<void> updateStudent(Student student) async {
    try {
      await _studentService.updateStudent(student);
      await loadStudents(); // Reload the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      await _studentService.deleteStudent(id);
      await loadStudents(); // Reload the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}