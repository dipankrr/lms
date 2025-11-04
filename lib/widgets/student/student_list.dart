// widgets/student/student_list.dart
import 'package:flutter/material.dart';
import 'package:lms/models/student.dart';

class StudentList extends StatelessWidget {
  final List<Student> students;

  const StudentList({required this.students});

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No students found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Try changing your filters or add new students',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Card(
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('Roll No')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Father Name')),
            DataColumn(label: Text('Class')),
            DataColumn(label: Text('Section')),
            DataColumn(label: Text('Actions')),
          ],
          rows: students.map((student) {
            return DataRow(
              cells: [
                DataCell(Text(student.rollNumber?.toString() ?? '-')),
                DataCell(Text(student.fullName)),
                DataCell(Text(student.fatherName ?? '-')),
                DataCell(FutureBuilder(
                  future: _getClassName(student.classId),
                  builder: (context, snapshot) {
                    return Text(snapshot.data ?? 'Loading...');
                  },
                )),
                DataCell(FutureBuilder(
                  future: _getSectionName(student.sectionId),
                  builder: (context, snapshot) {
                    return Text(snapshot.data ?? '-');
                  },
                )),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Navigate to edit screen
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteDialog(context, student);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<String?> _getClassName(String classId) async {
    // Implement class name lookup
    return 'Class Name';
  }

  Future<String?> _getSectionName(String? sectionId) async {
    if (sectionId == null) return null;
    // Implement section name lookup
    return 'Section Name';
  }

  void _showDeleteDialog(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement delete
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}