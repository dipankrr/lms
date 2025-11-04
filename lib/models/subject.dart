// models/subject.dart
class Subject {
  final String id;
  final String name;
  final double passMarks;
  final double totalMarks;
  final int orderIndex;
  final DateTime createdAt;

  Subject({
    required this.id,
    required this.name,
    required this.passMarks,
    required this.totalMarks,
    required this.orderIndex,
    required this.createdAt,
  });

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      passMarks: (map['pass_marks'] ?? 33.0).toDouble(),
      totalMarks: (map['total_marks'] ?? 100.0).toDouble(),
      orderIndex: map['order_index'] ?? 0,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'pass_marks': passMarks,
      'total_marks': totalMarks,
      'order_index': orderIndex,
    };
  }
}