import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  // Initialize Supabase (we'll call this later)
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'YOUR_SUPABASE_URL', // Will be configured later
      anonKey: 'YOUR_SUPABASE_ANON_KEY', // Will be configured later
    );
  }

  // Generic fetch method
  static Future<List<Map<String, dynamic>>> fetchData(String tableName) async {
    try {
      final response = await client.from(tableName).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch data from $tableName: $e');
    }
  }

  // Generic insert method
  static Future<Map<String, dynamic>> insertData(
      String tableName, Map<String, dynamic> data) async {
    try {
      final response = await client.from(tableName).insert(data).select().single();
      return response;
    } catch (e) {
      throw Exception('Failed to insert data to $tableName: $e');
    }
  }

  // Generic update method
  static Future<Map<String, dynamic>> updateData(
      String tableName, String id, Map<String, dynamic> data) async {
    try {
      final response = await client
          .from(tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();
      return response;
    } catch (e) {
      throw Exception('Failed to update data in $tableName: $e');
    }
  }

  // Generic delete method
  static Future<void> deleteData(String tableName, String id) async {
    try {
      await client.from(tableName).delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete data from $tableName: $e');
    }
  }
}