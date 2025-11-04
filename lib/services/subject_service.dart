// services/subject_service.dart
import 'package:lms/models/subject.dart';
import 'supabase_service.dart';

class SubjectService {
  final _supabase = SupabaseService().client;

  Future<List<Subject>> getSubjects() async {
    try {
      final data = await _supabase
          .from('subjects')
          .select()
          .order('order_index');
      return data.map<Subject>((json) => Subject.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch subjects: $e');
    }
  }

  Future<void> addSubject(Subject subject) async {
    try {
      await _supabase.from('subjects').insert(subject.toMap());
    } catch (e) {
      throw Exception('Failed to add subject: $e');
    }
  }

  Future<void> updateSubject(Subject subject) async {
    try {
      await _supabase
          .from('subjects')
          .update(subject.toMap())
          .eq('id', subject.id);
    } catch (e) {
      throw Exception('Failed to update subject: $e');
    }
  }

  Future<void> deleteSubject(String id) async {
    try {
      await _supabase.from('subjects').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete subject: $e');
    }
  }
}