// models/student.dart
class Student {
  final String id;
  final String admissionNo;
  final String fullName;
  final String? fatherName;
  final String classId;
  final String? sectionId;
  final int? rollNumber;
  final int academicYear;
  final DateTime? dateOfBirth;
  final String? address;
  final String? photoUrl;
  final DateTime createdAt;

  Student({
    required this.id,
    required this.admissionNo,
    required this.fullName,
    this.fatherName,
    required this.classId,
    this.sectionId,
    this.rollNumber,
    this.academicYear = 2026,
    this.dateOfBirth,
    this.address,
    this.photoUrl,
    required this.createdAt,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? '',
      admissionNo: map['admission_no'] ?? '',
      fullName: map['full_name'] ?? '',
      fatherName: map['father_name'],
      classId: map['class_id'] ?? '',
      sectionId: map['section_id'],
      rollNumber: map['roll_number'],
      academicYear: map['academic_year'] ?? 2026,
      dateOfBirth: map['date_of_birth'] != null
          ? DateTime.parse(map['date_of_birth'])
          : null,
      address: map['address'],
      photoUrl: map['photo_url'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'admission_no': admissionNo,
      'full_name': fullName,
      'father_name': fatherName,
      'class_id': classId,
      'section_id': sectionId,
      'roll_number': rollNumber,
      'academic_year': academicYear,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'address': address,
      'photo_url': photoUrl,
    };
  }
}