// models/marks.dart
class StudentMarks {
  final String studentId;
  final String studentName;
  final int? rollNumber;
  final String section;
  final Map<String, MarkEntry> subjectMarks; // subjectId -> MarkEntry

  StudentMarks({
    required this.studentId,
    required this.studentName,
    required this.rollNumber,
    required this.section,
    required this.subjectMarks,
  });
}

class MarkEntry {
  final double? marksObtained;
  final bool isAbsent;
  final String subjectName;
  final double totalMarks;
  final double passMarks;

  MarkEntry({
    this.marksObtained,
    required this.isAbsent,
    required this.subjectName,
    required this.totalMarks,
    required this.passMarks,
  });

  bool get isPassed {
    if (isAbsent) return false;
    if (marksObtained == null) return false;
    return marksObtained! >= passMarks;
  }

  double get percentage {
    if (marksObtained == null) return 0.0;
    return (marksObtained! / totalMarks) * 100;
  }
}