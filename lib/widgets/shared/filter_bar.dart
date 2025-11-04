// widgets/shared/filter_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lms/services/class_service.dart';

class FilterBar extends StatefulWidget {
  final Function(Map<String, String?>) onFilterChanged;

  const FilterBar({required this.onFilterChanged});

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  final ClassService _classService = ClassService();

  String? _selectedClassId;
  String? _selectedSectionId;
  List<dynamic> _classes = [];
  List<dynamic> _sections = [];

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
      });
    } catch (e) {
      print('Error loading classes: $e');
    }
  }

  Future<void> _loadSections(String classId) async {
    try {
      final sections = await _classService.getSections(classId);
      setState(() {
        _sections = sections;
        _selectedSectionId = null;
      });
    } catch (e) {
      print('Error loading sections: $e');
    }
  }

  void _onClassChanged(String? classId) {
    setState(() {
      _selectedClassId = classId;
      _selectedSectionId = null;
    });

    if (classId != null) {
      _loadSections(classId);
    } else {
      setState(() {
        _sections = [];
      });
    }

    _notifyFilterChange();
  }

  void _onSectionChanged(String? sectionId) {
    setState(() {
      _selectedSectionId = sectionId;
    });
    _notifyFilterChange();
  }

  void _notifyFilterChange() {
    widget.onFilterChanged({
      'classId': _selectedClassId,
      'sectionId': _selectedSectionId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Text('Filters:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 16),

            // Class Dropdown
            DropdownButton<String>(
              value: _selectedClassId,
              hint: Text('Select Class'),
              items: _classes.map<DropdownMenuItem<String>>((classItem) {
                return DropdownMenuItem<String>(
                  value: classItem.id,
                  child: Text(classItem.name),
                );
              }).toList(),
              onChanged: _onClassChanged,
            ),
            SizedBox(width: 16),

            // Section Dropdown
            DropdownButton<String>(
              value: _selectedSectionId,
              hint: Text('Select Section'),
              items: _sections.map<DropdownMenuItem<String>>((section) {
                return DropdownMenuItem<String>(
                  value: section.id,
                  child: Text(section.name),
                );
              }).toList(),
              onChanged: _onSectionChanged,
            ),

            // Clear Filters
            if (_selectedClassId != null || _selectedSectionId != null)
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedClassId = null;
                    _selectedSectionId = null;
                    _sections = [];
                  });
                  _notifyFilterChange();
                },
                child: Text('Clear Filters'),
              ),
          ],
        ),
      ),
    );
  }
}