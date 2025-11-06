// widgets/marks/marks_table.dart
import 'package:flutter/material.dart';
import 'package:lms/models/marks.dart';
import 'marks_input_cell.dart';

class MarksTable extends StatelessWidget {
  final List<StudentMarks> studentMarks;
  final Function(String studentId, String subjectId, double? marks, bool isAbsent) onMarksUpdated;

  const MarksTable({
    required this.studentMarks,
    required this.onMarksUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final subjects = _getSubjects();

    return Card(
      elevation: 2,
      child: Column(
        children: [
          isMobile ? _MobileHeader() : _DesktopHeader(subjects: subjects),
          Expanded(
            child: isMobile
                ? _buildMobileList(subjects)
                : _buildDesktopTable(subjects),
          ),
        ],
      ),
    );
  }

  List<String> _getSubjects() {
    return studentMarks.isNotEmpty
        ? studentMarks.first.subjectMarks.keys.toList()
        : [];
  }

  Widget _buildDesktopTable(List<String> subjects) {
    return ListView.builder(
      itemCount: studentMarks.length,
      itemBuilder: (context, index) => _DesktopRow(
        studentMarks: studentMarks[index],
        subjects: subjects,
        onMarksUpdated: onMarksUpdated,
      ),
    );
  }

  Widget _buildMobileList(List<String> subjects) {
    return ListView.builder(
      itemCount: studentMarks.length,
      itemBuilder: (context, index) => _MobileItem(
        studentMarks: studentMarks[index],
        subjects: subjects,
        onMarksUpdated: onMarksUpdated,
      ),
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  final List<String> subjects;

  const _DesktopHeader({required this.subjects});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          _HeaderText('Roll No', flex: 2),
          _HeaderText('Student Name', flex: 3),
          _HeaderText('Section', flex: 2),
          for (final subjectId in subjects)
            _HeaderText('Subject', flex: 2, isCentered: true),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  final int flex;
  final bool isCentered;

  const _HeaderText(this.text, {required this.flex, this.isCentered = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: isCentered ? TextAlign.center : TextAlign.left,
      ),
    );
  }
}

class _MobileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Students & Marks', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('Tap student to view/edit marks', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _DesktopRow extends StatelessWidget {
  final StudentMarks studentMarks;
  final List<String> subjects;
  final Function(String studentId, String subjectId, double? marks, bool isAbsent) onMarksUpdated;

  const _DesktopRow({
    required this.studentMarks,
    required this.subjects,
    required this.onMarksUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          _RowText(studentMarks.rollNumber?.toString() ?? '-', flex: 2),
          _RowText(studentMarks.studentName, flex: 3),
          _RowText(studentMarks.section, flex: 2),
          for (final subjectId in subjects)
            Expanded(
              flex: 2,
              child: MarksInputCell(
                markEntry: studentMarks.subjectMarks[subjectId]!,
                onChanged: (marks, isAbsent) {
                  onMarksUpdated(studentMarks.studentId, subjectId, marks, isAbsent);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _RowText extends StatelessWidget {
  final String text;
  final int flex;

  const _RowText(this.text, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: flex, child: Text(text));
  }
}

class _MobileItem extends StatelessWidget {
  final StudentMarks studentMarks;
  final List<String> subjects;
  final Function(String studentId, String subjectId, double? marks, bool isAbsent) onMarksUpdated;

  const _MobileItem({
    required this.studentMarks,
    required this.subjects,
    required this.onMarksUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Center(child: Text(studentMarks.rollNumber?.toString() ?? '?')),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(studentMarks.studentName, overflow: TextOverflow.ellipsis),
                  Text(studentMarks.section, style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.5,
              ),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subjectId = subjects[index];
                return MarksInputCell(
                  markEntry: studentMarks.subjectMarks[subjectId]!,
                  onChanged: (marks, isAbsent) {
                    onMarksUpdated(studentMarks.studentId, subjectId, marks, isAbsent);
                  },
                  isMobile: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}