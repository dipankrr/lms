// services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseKey = 'YOUR_SUPABASE_KEY';

  late final SupabaseClient client;

  Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://vebwasgmfjjqbtbtxplh.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZlYndhc2dtZmpqcWJ0YnR4cGxoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIyNjY0NTgsImV4cCI6MjA3Nzg0MjQ1OH0.2R27YhzU4rLJgejXslE8K-MB63fKvaRLFbAKAMeNjUI',
    );
    client = Supabase.instance.client;
  }

  // Test connection
  Future<bool> testConnection() async {
    try {
      final response = await client.from('academic_years').select().limit(1);
      return true;
    } catch (e) {
      return false;
    }
  }
}