// screens/students_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lms/controllers/student_controller.dart';
import 'package:lms/widgets/shared/filter_bar.dart';
import 'package:lms/widgets/student/student_list.dart';

class StudentsScreen extends StatefulWidget {
  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentController>(context, listen: false).loadStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar is already in Dashboard, so just main content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Students',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/add-student');
                        },
                        icon: Icon(Icons.add),
                        label: Text('Add Student'),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Filters
                  FilterBar(
                    onFilterChanged: (filters) {
                      Provider.of<StudentController>(context, listen: false)
                          .loadStudents(
                        classId: filters['classId'],
                        sectionId: filters['sectionId'],
                      );
                    },
                  ),
                  SizedBox(height: 24),

                  // Student List
                  Expanded(
                    child: Consumer<StudentController>(
                      builder: (context, controller, child) {
                        if (controller.isLoading) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (controller.error != null) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, size: 64, color: Colors.red),
                                SizedBox(height: 16),
                                Text(
                                  'Error: ${controller.error}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => controller.loadStudents(),
                                  child: Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }

                        return StudentList(students: controller.students);
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