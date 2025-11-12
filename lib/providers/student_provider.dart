import 'package:flutter/foundation.dart';
import '../models/student_model.dart';
import '../models/academic_year_model.dart';
import '../models/class_model.dart';
import '../models/section_model.dart';
import '../services/supabase_service.dart';

class StudentProvider with ChangeNotifier {
  List<Student> _students = [];
  List<AcademicYear> _academicYears = [];
  List<Class> _classes = [];
  List<Section> _sections = [];

  // Filter states
  String? _selectedAcademicYearId;
  String? _selectedClassId;
  String? _selectedSectionId;

  // Loading states
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Student> get students => _students;
  List<AcademicYear> get academicYears => _academicYears;
  List<Class> get classes => _classes;
  List<Section> get sections => _sections;

  String? get selectedAcademicYearId => _selectedAcademicYearId;
  String? get selectedClassId => _selectedClassId;
  String? get selectedSectionId => _selectedSectionId;

  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filtered students based on selections
  List<Student> get filteredStudents {
    var filtered = _students;

    if (_selectedAcademicYearId != null) {
      filtered = filtered.where((student) =>
      student.admissionYearId == _selectedAcademicYearId
      ).toList();
    }

    if (_selectedClassId != null) {
      filtered = filtered.where((student) =>
      student.classId == _selectedClassId
      ).toList();
    }

    if (_selectedSectionId != null) {
      filtered = filtered.where((student) =>
      student.sectionId == _selectedSectionId
      ).toList();
    }

    return filtered;
  }

  // Get sections for selected class
  List<Section> get sectionsForSelectedClass {
    if (_selectedClassId == null) return [];
    return _sections.where((section) => section.classId == _selectedClassId).toList();
  }

  // Load all initial data
  Future<void> loadInitialData() async {
    await _loadAcademicYears();
    await _loadClasses();
    await _loadSections();
    await _loadStudents();
  }

  // Load students from Supabase
  Future<void> _loadStudents() async {
    _setLoading(true);
    try {
      // TODO: Replace with actual Supabase call
      // final data = await SupabaseService.fetchData('students');
      // _students = data.map((map) => Student.fromMap(map)).toList();

      // Temporary mock data for testing
      _students = [];
      _error = null;
    } catch (e) {
      _error = 'Failed to load students: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Load academic years from Supabase
  Future<void> _loadAcademicYears() async {
    try {
      // TODO: Replace with actual Supabase call
      // final data = await SupabaseService.fetchData('academic_years');
      // _academicYears = data.map((map) => AcademicYear.fromMap(map)).toList();

      // Temporary mock data for testing
      _academicYears = [
        AcademicYear(
          id: '1',
          year: '2023-2024',
          isActive: true,
          createdAt: DateTime.now(),
        ),
        AcademicYear(
          id: '2',
          year: '2024-2025',
          isActive: false,
          createdAt: DateTime.now(),
        ),
      ];
    } catch (e) {
      _error = 'Failed to load academic years: $e';
    }
  }

  // Load classes from Supabase
  Future<void> _loadClasses() async {
    try {
      // TODO: Replace with actual Supabase call
      // final data = await SupabaseService.fetchData('classes');
      // _classes = data.map((map) => Class.fromMap(map)).toList();

      // Temporary mock data for testing
      _classes = [
        Class(id: '1', name: 'Class 1', orderIndex: 1, createdAt: DateTime.now()),
        Class(id: '2', name: 'Class 2', orderIndex: 2, createdAt: DateTime.now()),
        Class(id: '3', name: 'Class 3', orderIndex: 3, createdAt: DateTime.now()),
      ];
    } catch (e) {
      _error = 'Failed to load classes: $e';
    }
  }

  // Load sections from Supabase
  Future<void> _loadSections() async {
    try {
      // TODO: Replace with actual Supabase call
      // final data = await SupabaseService.fetchData('sections');
      // _sections = data.map((map) => Section.fromMap(map)).toList();

      // Temporary mock data for testing
      _sections = [
        Section(id: '1', classId: '1', name: 'A', orderIndex: 1, createdAt: DateTime.now()),
        Section(id: '2', classId: '1', name: 'B', orderIndex: 2, createdAt: DateTime.now()),
        Section(id: '3', classId: '2', name: 'A', orderIndex: 1, createdAt: DateTime.now()),
        Section(id: '4', classId: '2', name: 'B', orderIndex: 2, createdAt: DateTime.now()),
      ];
    } catch (e) {
      _error = 'Failed to load sections: $e';
    }
  }

  // Filter methods
  void setAcademicYearFilter(String? academicYearId) {
    _selectedAcademicYearId = academicYearId;
    notifyListeners();
  }

  void setClassFilter(String? classId) {
    _selectedClassId = classId;
    _selectedSectionId = null; // Reset section when class changes
    notifyListeners();
  }

  void setSectionFilter(String? sectionId) {
    _selectedSectionId = sectionId;
    notifyListeners();
  }

  void clearFilters() {
    _selectedAcademicYearId = null;
    _selectedClassId = null;
    _selectedSectionId = null;
    notifyListeners();
  }

  // Add student
  Future<void> addStudent(Student student) async {
    _setLoading(true);
    try {
      // TODO: Replace with actual Supabase call
       await SupabaseService.insertData('students', student.toMap());
      await _loadStudents(); // Reload students
    } catch (e) {
      _error = 'Failed to add student: $e';
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Update student
  Future<void> updateStudent(Student student) async {
    _setLoading(true);
    try {
      // TODO: Replace with actual Supabase call
      // await SupabaseService.updateData('students', student.id, student.toMap());
      await _loadStudents(); // Reload students
    } catch (e) {
      _error = 'Failed to update student: $e';
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Delete student
  Future<void> deleteStudent(String studentId) async {
    _setLoading(true);
    try {
      // TODO: Replace with actual Supabase call
      // await SupabaseService.deleteData('students', studentId);
      await _loadStudents(); // Reload students
    } catch (e) {
      _error = 'Failed to delete student: $e';
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}