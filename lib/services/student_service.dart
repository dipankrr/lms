// services/student_service.dart
import 'package:lms/models/student.dart';
import 'supabase_service.dart';

class StudentService {
  final _supabase = SupabaseService().client;

// services/student_service.dart - UPDATE GET STUDENTS
  Future<List<Student>> getStudents({
    String? classId,
    String? sectionId,
    int? academicYear,
  }) async {
    try {
      dynamic query = _supabase.from('students').select('''
      *,
      classes(name),
      sections(name)
    ''');

      if (classId != null) {
        query = query.eq('class_id', classId);
      }
      if (sectionId != null) {
        query = query.eq('section_id', sectionId);
      }
      if (academicYear != null) {
        query = query.eq('academic_year', academicYear);
      }

      query = query.order('roll_number');

      final data = await query;
      return data.map<Student>((json) => Student.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  Future<void> addStudent(Student student) async {
    try {
      await _supabase.from('students').insert(student.toMap());
    } catch (e) {
      throw Exception('Failed to add student: $e');
    }
  }

  Future<void> updateStudent(Student student) async {
    try {
      await _supabase
          .from('students')
          .update(student.toMap())
          .eq('id', student.id);
    } catch (e) {
      throw Exception('Failed to update student: $e');
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      await _supabase.from('students').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete student: $e');
    }
  }
}