import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/adaptive_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/responsive_dropdown.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../providers/student_provider.dart';
import '../../models/student_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/responsive_utils.dart';

class AddEditStudentScreen extends StatefulWidget {
  final Student? student;

  const AddEditStudentScreen({super.key, this.student});

  @override
  State<AddEditStudentScreen> createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends State<AddEditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Controllers for all fields
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _aadharController = TextEditingController();
  final _motherTongueController = TextEditingController();

  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _fatherOccupationController = TextEditingController();
  final _motherOccupationController = TextEditingController();

  final _phoneController = TextEditingController();
  final _phone2Controller = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();

  final _addressController = TextEditingController();
  final _postOfficeController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _policeStationController = TextEditingController();
  final _districtController = TextEditingController();

  final _admissionCodeController = TextEditingController();
  final _refNoDateController = TextEditingController();
  final _rollNumberController = TextEditingController();

  // Dropdown values
  String? _selectedAcademicYearId;
  String? _selectedClassId;
  String? _selectedSectionId;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.student != null) {
      // Edit mode - populate fields
      final student = widget.student!;

      _nameController.text = student.name;
      _dobController.text = student.dob != null
          ? DateFormat('dd/MM/yyyy').format(student.dob!)
          : '';
      _genderController.text = student.gender ?? '';
      _bloodGroupController.text = student.bloodGroup ?? '';
      _aadharController.text = student.aadharNumber ?? '';
      _motherTongueController.text = student.motherTongue ?? '';

      _fatherNameController.text = student.fatherName ?? '';
      _motherNameController.text = student.motherName ?? '';
      _fatherOccupationController.text = student.fatherOccupation ?? '';
      _motherOccupationController.text = student.motherOccupation ?? '';

      _phoneController.text = student.phoneNumber ?? '';
      _phone2Controller.text = student.phoneNumber2 ?? '';
      _emailController.text = student.email ?? '';
      _whatsappController.text = student.whatsappNo ?? '';

      _addressController.text = student.address ?? '';
      _postOfficeController.text = student.postOffice ?? '';
      _pincodeController.text = student.pincode ?? '';
      _policeStationController.text = student.policeStation ?? '';
      _districtController.text = student.district ?? '';

      _admissionCodeController.text = student.admissionCode ?? '';
      _refNoDateController.text = student.refNoDate != null
          ? DateFormat('dd/MM/yyyy').format(student.refNoDate!)
          : '';
      _rollNumberController.text = student.rollNumber;

      _selectedAcademicYearId = student.admissionYearId;
      _selectedClassId = student.classId;
      _selectedSectionId = student.sectionId;
    }
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final provider = Provider.of<StudentProvider>(context, listen: false);

      final student = Student(
        id: widget.student?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        dob: _dobController.text.isNotEmpty
            ? DateFormat('dd/MM/yyyy').parse(_dobController.text)
            : null,
        gender: _genderController.text.trim().isNotEmpty ? _genderController.text.trim() : null,
        bloodGroup: _bloodGroupController.text.trim().isNotEmpty ? _bloodGroupController.text.trim() : null,
        aadharNumber: _aadharController.text.trim().isNotEmpty ? _aadharController.text.trim() : null,
        motherTongue: _motherTongueController.text.trim().isNotEmpty ? _motherTongueController.text.trim() : null,
        fatherName: _fatherNameController.text.trim().isNotEmpty ? _fatherNameController.text.trim() : null,
        motherName: _motherNameController.text.trim().isNotEmpty ? _motherNameController.text.trim() : null,
        fatherOccupation: _fatherOccupationController.text.trim().isNotEmpty ? _fatherOccupationController.text.trim() : null,
        motherOccupation: _motherOccupationController.text.trim().isNotEmpty ? _motherOccupationController.text.trim() : null,
        phoneNumber: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
        phoneNumber2: _phone2Controller.text.trim().isNotEmpty ? _phone2Controller.text.trim() : null,
        email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
        whatsappNo: _whatsappController.text.trim().isNotEmpty ? _whatsappController.text.trim() : null,
        address: _addressController.text.trim().isNotEmpty ? _addressController.text.trim() : null,
        postOffice: _postOfficeController.text.trim().isNotEmpty ? _postOfficeController.text.trim() : null,
        pincode: _pincodeController.text.trim().isNotEmpty ? _pincodeController.text.trim() : null,
        policeStation: _policeStationController.text.trim().isNotEmpty ? _policeStationController.text.trim() : null,
        district: _districtController.text.trim().isNotEmpty ? _districtController.text.trim() : null,
        admissionYearId: _selectedAcademicYearId!,
        admissionCode: _admissionCodeController.text.trim().isNotEmpty ? _admissionCodeController.text.trim() : null,
        refNoDate: _refNoDateController.text.isNotEmpty
            ? DateFormat('dd/MM/yyyy').parse(_refNoDateController.text)
            : null,
        classId: _selectedClassId!,
        sectionId: _selectedSectionId,
        rollNumber: _rollNumberController.text.trim(),
        createdAt: widget.student?.createdAt ?? DateTime.now(),
      );

      if (widget.student == null) {
        await provider.addStudent(student);
        _showSuccess('Student added successfully!');
      } else {
        await provider.updateStudent(student);
        _showSuccess('Student updated successfully!');
      }

      Navigator.of(context).pop();
    } catch (e) {
      _showError('Failed to save student: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background2,
      appBar: CustomAppBar(
        title: widget.student == null ? 'Add Student' : 'Edit Student',
      ),
      body: Consumer<StudentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingIndicator(message: 'Saving student...');
          }

          return _buildForm(context, provider);
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, StudentProvider provider) {
    return Form(
      key: _formKey,
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.all(
            ResponsiveUtils.responsiveValue(context, 16.0, 20.0, 24.0),
          ),
          child: Column(
            children: [
              // Personal Information Section
              _buildSectionHeader('Personal Information'),
              _buildPersonalInfoSection(),

              const SizedBox(height: 24),

              // Parent Information Section
              _buildSectionHeader('Parent Information'),
              _buildParentInfoSection(),

              const SizedBox(height: 24),

              // Contact Information Section
              _buildSectionHeader('Contact Information'),
              _buildContactInfoSection(),

              const SizedBox(height: 24),

              // Address Information Section
              _buildSectionHeader('Address Information'),
              _buildAddressInfoSection(),

              const SizedBox(height: 24),

              // Academic Information Section
              _buildSectionHeader('Academic Information'),
              _buildAcademicInfoSection(context, provider),

              const SizedBox(height: 32),

              // Save Button
              _buildSaveButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      children: [
        CustomTextField(
          controller: _nameController,
          label: 'Full Name *',
          hint: 'Enter student full name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter student name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _dobController,
                label: 'Date of Birth',
                hint: 'DD/MM/YYYY',
                // TODO: [error] readOnly: true,
                // TODO: [error] onTap: () => _selectDate(_dobController),
                suffixIcon: Icons.calendar_today,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _genderController,
                label: 'Gender',
                hint: 'Enter gender',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _bloodGroupController,
                label: 'Blood Group',
                hint: 'Enter blood group',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _aadharController,
                label: 'Aadhar Number',
                hint: 'Enter Aadhar number',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _motherTongueController,
          label: 'Mother Tongue',
          hint: 'Enter mother tongue',
        ),
      ],
    );
  }

  Widget _buildParentInfoSection() {
    return Column(
      children: [
        CustomTextField(
          controller: _fatherNameController,
          label: 'Father\'s Name',
          hint: 'Enter father\'s name',
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _motherNameController,
          label: 'Mother\'s Name',
          hint: 'Enter mother\'s name',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _fatherOccupationController,
                label: 'Father\'s Occupation',
                hint: 'Enter occupation',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _motherOccupationController,
                label: 'Mother\'s Occupation',
                hint: 'Enter occupation',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return Column(
      children: [
        CustomTextField(
          controller: _phoneController,
          label: 'Phone Number',
          hint: 'Enter phone number',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _phone2Controller,
          label: 'Alternate Phone Number',
          hint: 'Enter alternate phone number',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _emailController,
          label: 'Email',
          hint: 'Enter email address',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _whatsappController,
          label: 'WhatsApp Number',
          hint: 'Enter WhatsApp number',
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildAddressInfoSection() {
    return Column(
      children: [
        CustomTextField(
          controller: _addressController,
          label: 'Address',
          hint: 'Enter complete address',
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _postOfficeController,
                label: 'Post Office',
                hint: 'Enter post office',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _pincodeController,
                label: 'Pincode',
                hint: 'Enter pincode',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _policeStationController,
                label: 'Police Station',
                hint: 'Enter police station',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _districtController,
                label: 'District',
                hint: 'Enter district',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAcademicInfoSection(BuildContext context, StudentProvider provider) {
    return Column(
      children: [
        // Academic Year Dropdown
        ResponsiveDropdown<String?>(
          label: 'Academic Year *',
          value: _selectedAcademicYearId,
          items: provider.academicYears.map((year) {
            return DropdownMenuItem<String?>(
              value: year.id,
              child: Text('${year.year} ${year.isActive ? '(Active)' : ''}'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedAcademicYearId = value);
          },
          validator: (value) {
            if (value == null) return 'Please select academic year';
            return null;
          },
          hint: 'Select Academic Year',
        ),
        const SizedBox(height: 16),

        // Class Dropdown
        ResponsiveDropdown<String?>(
          label: 'Class *',
          value: _selectedClassId,
          items: provider.classes.map((classItem) {
            return DropdownMenuItem<String?>(
              value: classItem.id,
              child: Text(classItem.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedClassId = value;
              _selectedSectionId = null; // Reset section when class changes
            });
          },
          validator: (value) {
            if (value == null) return 'Please select class';
            return null;
          },
          hint: 'Select Class',
        ),
        const SizedBox(height: 16),

        // Section Dropdown (only if class is selected)
        if (_selectedClassId != null) ...[
          ResponsiveDropdown<String?>(
            label: 'Section',
            value: _selectedSectionId,
            items: provider.sections
                .where((section) => section.classId == _selectedClassId)
                .map((section) {
              return DropdownMenuItem<String?>(
                value: section.id,
                child: Text(section.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedSectionId = value);
            },
            hint: 'Select Section',
          ),
          const SizedBox(height: 16),
        ],

        // Roll Number
        CustomTextField(
          controller: _rollNumberController,
          label: 'Roll Number *',
          hint: 'Enter roll number',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter roll number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Admission Code and Reference Date
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _admissionCodeController,
                label: 'Admission Code',
                hint: 'Enter admission code',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _refNoDateController,
                label: 'Reference Date',
                hint: 'DD/MM/YYYY',
                // TODO: [error] readOnly: true,
                // TODO: [error] onTap: () => _selectDate(_refNoDateController),
                suffixIcon: Icons.calendar_today,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return AdaptiveButton(
      onPressed: _isLoading ? null : _saveStudent,
      text: _isLoading
          ? 'Saving...'
          : widget.student == null ? 'Add Student' : 'Update Student',
      fullWidth: true,
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    _nameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _bloodGroupController.dispose();
    _aadharController.dispose();
    _motherTongueController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _fatherOccupationController.dispose();
    _motherOccupationController.dispose();
    _phoneController.dispose();
    _phone2Controller.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _addressController.dispose();
    _postOfficeController.dispose();
    _pincodeController.dispose();
    _policeStationController.dispose();
    _districtController.dispose();
    _admissionCodeController.dispose();
    _refNoDateController.dispose();
    _rollNumberController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}