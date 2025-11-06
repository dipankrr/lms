// services/marks_service.dart
import 'package:lms/models/marks.dart';
import 'supabase_service.dart';

class MarksService {
  final _supabase = SupabaseService().client;

  Future<List<StudentMarks>> getMarksForClass({
    required String classId,
    String? sectionId,
    required int term,
    required int academicYear,
  }) async {
    try {
      // Get students for the class/section
      dynamic studentQuery = _supabase
          .from('students')
          .select('id, full_name, roll_number, sections(name)')
          .eq('class_id', classId)
          .eq('academic_year', academicYear);

      if (sectionId != null) {
        studentQuery = studentQuery.eq('section_id', sectionId);
      }

      studentQuery = studentQuery.order('roll_number');

      final students = await studentQuery;

      // Get all subjects
      final subjects = await _supabase
          .from('subjects')
          .select()
          .order('order_index');

      // Get existing marks for these students and term
      final existingMarks = await _supabase
          .from('marks')
          .select()
          .inFilter('student_id', students.map((s) => s['id']).toList())
          .eq('term', term)
          .eq('academic_year', academicYear);

      // Create StudentMarks objects
      List<StudentMarks> studentMarksList = [];

      for (var student in students) {
        final studentMarks = StudentMarks(
          studentId: student['id'],
          studentName: student['full_name'],
          rollNumber: student['roll_number'],
          section: student['sections']?['name'] ?? 'No Section',
          subjectMarks: {},
        );

        // Initialize marks for each subject
        for (var subject in subjects) {
          final existingMark = existingMarks.firstWhere(
                (mark) => mark['student_id'] == student['id'] &&
                mark['subject_id'] == subject['id'],
            orElse: () => {},
          );

          studentMarks.subjectMarks[subject['id']] = MarkEntry(
            marksObtained: existingMark['marks_obtained']?.toDouble(),
            isAbsent: existingMark['is_absent'] ?? false,
            subjectName: subject['name'],
            totalMarks: subject['total_marks']?.toDouble() ?? 100.0,
            passMarks: subject['pass_marks']?.toDouble() ?? 33.0,
          );
        }

        studentMarksList.add(studentMarks);
      }

      return studentMarksList;
    } catch (e) {
      throw Exception('Failed to fetch marks: $e');
    }
  }

  Future<void> saveMarks({
    required String studentId,
    required String subjectId,
    required int term,
    required int academicYear,
    required double? marksObtained,
    required bool isAbsent,
  }) async {
    try {
      final markData = {
        'student_id': studentId,
        'subject_id': subjectId,
        'term': term,
        'academic_year': academicYear,
        'marks_obtained': marksObtained,
        'is_absent': isAbsent,
      };

      // Use upsert to handle both insert and update
      await _supabase.from('marks').upsert(markData);
    } catch (e) {
      throw Exception('Failed to save marks: $e');
    }
  }

  // services/marks_service.dart - ADD THIS METHOD
  Future<List<Map<String, dynamic>>> getExistingMarks({
    required List<String> studentIds,
    required int term,
    required int academicYear,
  }) async {
    try {
      if (studentIds.isEmpty) return [];

      final data = await _supabase
          .from('marks')
          .select()
          .inFilter('student_id', studentIds)
          .eq('term', term)
          .eq('academic_year', academicYear);

      return data;
    } catch (e) {
      throw Exception('Failed to fetch existing marks: $e');
    }
  }

  Future<void> saveAllMarks(List<StudentMarks> allMarks, int term) async {
    try {
      // Batch save all marks
      for (var studentMarks in allMarks) {
        for (var entry in studentMarks.subjectMarks.entries) {
          final subjectId = entry.key;
          final markEntry = entry.value;

          await saveMarks(
            studentId: studentMarks.studentId,
            subjectId: subjectId,
            term: term,
            academicYear: 2026,
            marksObtained: markEntry.marksObtained,
            isAbsent: markEntry.isAbsent,
          );
        }
      }
    } catch (e) {
      throw Exception('Failed to save all marks: $e');
    }
  }
}