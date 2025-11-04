// screens/subjects_screen.dart
import 'package:flutter/material.dart';
import 'package:lms/models/subject.dart';
import 'package:lms/services/subject_service.dart';

class SubjectsScreen extends StatefulWidget {
  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final SubjectService _subjectService = SubjectService();
  List<Subject> _subjects = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    try {
      final subjects = await _subjectService.getSubjects();
      setState(() {
        _subjects = subjects;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showAddSubjectDialog() {
    showDialog(
      context: context,
      builder: (context) => AddSubjectDialog(onSubjectAdded: _loadSubjects),
    );
  }

  void _showEditSubjectDialog(Subject subject) {
    showDialog(
      context: context,
      builder: (context) => AddSubjectDialog(
        subject: subject,
        onSubjectAdded: _loadSubjects,
      ),
    );
  }

  Future<void> _deleteSubject(Subject subject) async {
    try {
      await _subjectService.deleteSubject(subject.id);
      _loadSubjects();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete subject: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subjects',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: _showAddSubjectDialog,
                        icon: Icon(Icons.add),
                        label: Text('Add Subject'),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  if (_isLoading)
                    Center(child: CircularProgressIndicator())
                  else if (_error != null)
                    Center(child: Text('Error: $_error'))
                  else
                    Expanded(
                      child: _subjects.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.subject, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No subjects added',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Add subjects to start entering marks',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                          : ListView.builder(
                        itemCount: _subjects.length,
                        itemBuilder: (context, index) {
                          return _SubjectCard(
                            subject: _subjects[index],
                            onEdit: _showEditSubjectDialog,
                            onDelete: _deleteSubject,
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final Subject subject;
  final Function(Subject) onEdit;
  final Function(Subject) onDelete;

  const _SubjectCard({
    required this.subject,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.subject, color: Colors.blue),
        ),
        title: Text(
          subject.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Pass Marks: ${subject.passMarks}/${subject.totalMarks}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => onEdit(subject),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteDialog(context, subject);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Subject subject) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Subject'),
        content: Text('Are you sure you want to delete ${subject.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onDelete(subject);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class AddSubjectDialog extends StatefulWidget {
  final Subject? subject;
  final VoidCallback onSubjectAdded;

  const AddSubjectDialog({
    this.subject,
    required this.onSubjectAdded,
  });

  @override
  _AddSubjectDialogState createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends State<AddSubjectDialog> {
  final _subjectNameController = TextEditingController();
  final _passMarksController = TextEditingController();
  final _totalMarksController = TextEditingController();
  final _subjectService = SubjectService();

  @override
  void initState() {
    super.initState();
    if (widget.subject != null) {
      _subjectNameController.text = widget.subject!.name;
      _passMarksController.text = widget.subject!.passMarks.toString();
      _totalMarksController.text = widget.subject!.totalMarks.toString();
    } else {
      _totalMarksController.text = '100';
      _passMarksController.text = '33';
    }
  }

  Future<void> _saveSubject() async {
    if (_subjectNameController.text.isEmpty) return;

    try {
      final subject = Subject(
        id: widget.subject?.id ?? '',
        name: _subjectNameController.text,
        passMarks: double.tryParse(_passMarksController.text) ?? 33.0,
        totalMarks: double.tryParse(_totalMarksController.text) ?? 100.0,
        orderIndex: 0,
        createdAt: widget.subject?.createdAt ?? DateTime.now(),
      );

      if (widget.subject != null) {
        await _subjectService.updateSubject(subject);
      } else {
        await _subjectService.addSubject(subject);
      }

      widget.onSubjectAdded();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save subject: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.subject != null ? 'Edit Subject' : 'Add New Subject'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _subjectNameController,
              decoration: InputDecoration(
                labelText: 'Subject Name',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _totalMarksController,
                    decoration: InputDecoration(
                      labelText: 'Total Marks',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _passMarksController,
                    decoration: InputDecoration(
                      labelText: 'Pass Marks',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveSubject,
          child: Text(widget.subject != null ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}