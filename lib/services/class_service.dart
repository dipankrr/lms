// services/class_service.dart
import '../models/class_model.dart';
import 'supabase_service.dart';

class ClassService {
  final _supabase = SupabaseService().client;

  Future<List<SchoolClass>> getClasses() async {
    try {
      final data = await _supabase
          .from('classes')
          .select()
          .order('order_index');
      return data.map<SchoolClass>((json) => SchoolClass.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch classes: $e');
    }
  }

  Future<void> addClass(SchoolClass schoolClass) async {
    try {
      await _supabase.from('classes').insert(schoolClass.toMap());
    } catch (e) {
      throw Exception('Failed to add class: $e');
    }
  }

  Future<List<Section>> getSections(String classId) async {
    try {
      final data = await _supabase
          .from('sections')
          .select()
          .eq('class_id', classId)
          .order('order_index');
      return data.map<Section>((json) => Section.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch sections: $e');
    }
  }

  Future<void> addSection(Section section) async {
    try {
      await _supabase.from('sections').insert(section.toMap());
    } catch (e) {
      throw Exception('Failed to add section: $e');
    }
  }
}