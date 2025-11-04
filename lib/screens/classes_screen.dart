// screens/classes_screen.dart
import 'package:flutter/material.dart';
import 'package:lms/services/class_service.dart';
import 'package:lms/models/class_model.dart';

class ClassesScreen extends StatefulWidget {
  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final ClassService _classService = ClassService();
  List<SchoolClass> _classes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    try {
      final classes = await _classService.getClasses();
      setState(() {
        _classes = classes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showAddClassDialog() {
    showDialog(
      context: context,
      builder: (context) => AddClassDialog(onClassAdded: _loadClasses),
    );
  }

  void _showAddSectionDialog(SchoolClass schoolClass) {
    showDialog(
      context: context,
      builder: (context) => AddSectionDialog(
        classId: schoolClass.id,
        onSectionAdded: _loadClasses,
      ),
    );
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
                        'Classes & Sections',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: _showAddClassDialog,
                        icon: Icon(Icons.add),
                        label: Text('Add Class'),
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
                      child: ListView.builder(
                        itemCount: _classes.length,
                        itemBuilder: (context, index) {
                          return _ClassCard(
                            schoolClass: _classes[index],
                            onAddSection: _showAddSectionDialog,
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

class _ClassCard extends StatelessWidget {
  final SchoolClass schoolClass;
  final Function(SchoolClass) onAddSection;

  const _ClassCard({
    required this.schoolClass,
    required this.onAddSection,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  schoolClass.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => onAddSection(schoolClass),
                  tooltip: 'Add Section',
                ),
              ],
            ),
            SizedBox(height: 16),
            FutureBuilder<List<Section>>(
              future: ClassService().getSections(schoolClass.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                  return Text(
                    'No sections added',
                    style: TextStyle(color: Colors.grey),
                  );
                }

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: snapshot.data!.map((section) {
                    return Chip(
                      label: Text(section.name),
                      backgroundColor: Colors.blue[50],
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddClassDialog extends StatefulWidget {
  final VoidCallback onClassAdded;

  const AddClassDialog({required this.onClassAdded});

  @override
  _AddClassDialogState createState() => _AddClassDialogState();
}

class _AddClassDialogState extends State<AddClassDialog> {
  final _classNameController = TextEditingController();
  final _classService = ClassService();

  Future<void> _addClass() async {
    if (_classNameController.text.isEmpty) return;

    try {
      final schoolClass = SchoolClass(
        id: '',
        name: _classNameController.text,
        orderIndex: 0,
        createdAt: DateTime.now(),
      );
      await _classService.addClass(schoolClass);
      widget.onClassAdded();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add class: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Class'),
      content: TextField(
        controller: _classNameController,
        decoration: InputDecoration(
          labelText: 'Class Name',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addClass,
          child: Text('Add Class'),
        ),
      ],
    );
  }
}

class AddSectionDialog extends StatefulWidget {
  final String classId;
  final VoidCallback onSectionAdded;

  const AddSectionDialog({
    required this.classId,
    required this.onSectionAdded,
  });

  @override
  _AddSectionDialogState createState() => _AddSectionDialogState();
}

class _AddSectionDialogState extends State<AddSectionDialog> {
  final _sectionNameController = TextEditingController();
  final _classService = ClassService();

  Future<void> _addSection() async {
    if (_sectionNameController.text.isEmpty) return;

    try {
      final section = Section(
        id: '',
        classId: widget.classId,
        name: _sectionNameController.text,
        orderIndex: 0,
        createdAt: DateTime.now(),
      );
      await _classService.addSection(section);
      widget.onSectionAdded();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add section: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Section'),
      content: TextField(
        controller: _sectionNameController,
        decoration: InputDecoration(
          labelText: 'Section Name',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addSection,
          child: Text('Add Section'),
        ),
      ],
    );
  }
}