# lms

student management app

-- 1. Academic Years Table
CREATE TABLE academic_years (
id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
year VARCHAR NOT NULL,
is_active BOOLEAN DEFAULT false,
created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Classes Table
CREATE TABLE classes (
id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
name VARCHAR NOT NULL,
order_index INTEGER DEFAULT 0,
created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Sections Table
CREATE TABLE sections (
id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
class_id UUID REFERENCES classes(id) ON DELETE CASCADE,
name VARCHAR NOT NULL,
order_index INTEGER DEFAULT 0,
created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Subjects Table
CREATE TABLE subjects (
id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
class_id UUID REFERENCES classes(id) ON DELETE CASCADE,
name VARCHAR NOT NULL,
total_marks INTEGER DEFAULT 100,
pass_marks INTEGER DEFAULT 40,
order_index INTEGER DEFAULT 0,
created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Students Table
CREATE TABLE students (
id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
-- Personal Info
name VARCHAR NOT NULL,
dob DATE,
gender VARCHAR,
blood_group VARCHAR,
aadhar_number VARCHAR,
mother_tongue VARCHAR,

-- Parent Info
father_name VARCHAR,
mother_name VARCHAR,
father_occupation VARCHAR,
mother_occupation VARCHAR,

-- Contact Info
phone_number VARCHAR,
phone_number_2 VARCHAR,
email VARCHAR,
whatsapp_no VARCHAR,

-- Address
address TEXT,
post_office VARCHAR,
pincode VARCHAR,
police_station VARCHAR,
district VARCHAR,

-- Academic Info
admission_year_id UUID REFERENCES academic_years(id),
admission_code VARCHAR,
ref_no_date DATE,
class_id UUID REFERENCES classes(id),
section_id UUID REFERENCES sections(id),
roll_number VARCHAR NOT NULL,

created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Marks Table
CREATE TABLE marks (
id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
student_id UUID REFERENCES students(id) ON DELETE CASCADE,
subject_id UUID REFERENCES subjects(id) ON DELETE CASCADE,
academic_year_id UUID REFERENCES academic_years(id),
term INTEGER CHECK (term IN (1, 2, 3)),
marks_obtained INTEGER DEFAULT 0,
is_absent BOOLEAN DEFAULT false,
created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security (RLS) - Important for security
ALTER TABLE academic_years ENABLE ROW LEVEL SECURITY;
ALTER TABLE classes ENABLE ROW LEVEL SECURITY;
ALTER TABLE sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE marks ENABLE ROW LEVEL SECURITY;

-- Create policies to allow all operations (since we're using hardcoded auth)
CREATE POLICY "Allow all operations" ON academic_years FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON classes FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON sections FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON subjects FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON students FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON marks FOR ALL USING (true);



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
│   ├──

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
