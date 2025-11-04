# lms

student management app

lib/
├── models/
│   ├── student.dart ✅
│   ├── class_model.dart ✅
│   ├── subject.dart ✅
│   └── marks.dart ✅
├── services/
│   ├── supabase_service.dart ✅
│   ├── student_service.dart ✅
│   ├── class_service.dart ✅
│   ├── subject_service.dart ✅ +
│   └── marks_service.dart ✅
├── controllers/
│   ├── auth_controller.dart ✅
│   ├── student_controller.dart ✅
│   ├── class_controller.dart
│   └── marks_controller.dart ✅
├── widgets/
│   ├── shared/ (filter_bar, data_table, etc.) #sidebar, 
│   ├── student/ (student_card, student_form)
│   ├── classes/ (class_form, section_form)
│   ├── subjects/ (subject_form, subject_list)
│   └── marks/ (marks_table, marks_cell)
├── screens/
│   ├── login_screen.dart ✅
│   ├── dashboard_screen.dart ✅
│   ├── classes_screen.dart ✅
│   ├── subjects_screen.dart ✅
│   ├── students_screen.dart ✅
│   ├── add_student_screen.dart ✅
│   ├── marks_screen.dart 
│   ├── id_card_screen.dart 
│   ├── admit_card_screen.dart 
│   └── results_screen.dart 
└── main.dart ✅

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
