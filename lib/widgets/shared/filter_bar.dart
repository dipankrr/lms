// widgets/shared/filter_bar.dart
import 'package:flutter/material.dart';
import 'package:lms/services/class_service.dart';
import 'package:lms/models/class_model.dart';
import 'custom_dropdown.dart';

class FilterBar extends StatefulWidget {
  final Function(Map<String, dynamic>) onFilterChanged;
  final Map<String, dynamic> initialFilters;

  const FilterBar({
    required this.onFilterChanged,
    this.initialFilters = const {},
  });

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  final ClassService _classService = ClassService();

  int _selectedYear = 2026;
  String? _selectedClassId;
  String? _selectedSectionId;
  int _selectedTerm = 1;

  final List<int> _academicYears = [2024, 2025, 2026, 2027, 2028];
  final List<int> _terms = [1, 2, 3];
  List<SchoolClass> _classes = [];
  List<Section> _sections = [];

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialFilters['year'] ?? 2026;
    _selectedClassId = widget.initialFilters['classId'];
    _selectedSectionId = widget.initialFilters['sectionId'];
    _selectedTerm = widget.initialFilters['term'] ?? 1;

    _loadClasses();
    _notifyFilters();
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
    _notifyFilters();
  }

  void _notifyFilters() {
    widget.onFilterChanged({
      'year': _selectedYear,
      'classId': _selectedClassId,
      'sectionId': _selectedSectionId,
      'term': _selectedTerm,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                // Year Dropdown
                SizedBox(
                  width: 150,
                  child: CustomDropdown<int>(
                    label: 'Academic Year',
                    value: _selectedYear,
                    items: _academicYears.map((year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }).toList(),
                    onChanged: (year) {
                      setState(() => _selectedYear = year!);
                      _notifyFilters();
                    },
                  ),
                ),

                // Class Dropdown - REAL DATA
                SizedBox(
                  width: 150,
                  child: CustomDropdown<String>(
                    label: 'Class',
                    value: _selectedClassId,
                    items: _classes.map((classItem) {
                      return DropdownMenuItem<String>(
                        value: classItem.id,
                        child: Text(classItem.name),
                      );
                    }).toList(),
                    onChanged: (classId) {
                      setState(() => _selectedClassId = classId);
                      if (classId != null) {
                        _loadSections(classId);
                      } else {
                        setState(() {
                          _sections = [];
                          _selectedSectionId = null;
                        });
                        _notifyFilters();
                      }
                    },
                  ),
                ),

                // Section Dropdown - REAL DATA
                SizedBox(
                  width: 150,
                  child: CustomDropdown<String>(
                    label: 'Section',
                    value: _selectedSectionId,
                    items: _sections.map((section) {
                      return DropdownMenuItem<String>(
                        value: section.id,
                        child: Text(section.name),
                      );
                    }).toList(),
                    onChanged: (sectionId) {
                      setState(() => _selectedSectionId = sectionId);
                      _notifyFilters();
                    },
                  ),
                ),

                // Term Dropdown
                SizedBox(
                  width: 150,
                  child: CustomDropdown<int>(
                    label: 'Term',
                    value: _selectedTerm,
                    items: _terms.map((term) {
                      return DropdownMenuItem<int>(
                        value: term,
                        child: Text('Term $term'),
                      );
                    }).toList(),
                    onChanged: (term) {
                      setState(() => _selectedTerm = term!);
                      _notifyFilters();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}