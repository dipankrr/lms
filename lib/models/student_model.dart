class Student {
  final String id;
  final String name;
  final DateTime? dob;
  final String? gender;
  final String? bloodGroup;
  final String? aadharNumber;
  final String? motherTongue;

  // Parent Info
  final String? fatherName;
  final String? motherName;
  final String? fatherOccupation;
  final String? motherOccupation;

  // Contact Info
  final String? phoneNumber;
  final String? phoneNumber2;
  final String? email;
  final String? whatsappNo;

  // Address
  final String? address;
  final String? postOffice;
  final String? pincode;
  final String? policeStation;
  final String? district;

  // Academic Info
  final String admissionYearId;
  final String? admissionCode;
  final DateTime? refNoDate;
  final String classId;
  final String? sectionId;
  final String rollNumber;

  final DateTime createdAt;

  Student({
    required this.id,
    required this.name,
    this.dob,
    this.gender,
    this.bloodGroup,
    this.aadharNumber,
    this.motherTongue,
    this.fatherName,
    this.motherName,
    this.fatherOccupation,
    this.motherOccupation,
    this.phoneNumber,
    this.phoneNumber2,
    this.email,
    this.whatsappNo,
    this.address,
    this.postOffice,
    this.pincode,
    this.policeStation,
    this.district,
    required this.admissionYearId,
    this.admissionCode,
    this.refNoDate,
    required this.classId,
    this.sectionId,
    required this.rollNumber,
    required this.createdAt,
  });

  // Convert to Map for Supabase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dob': dob?.toIso8601String(),
      'gender': gender,
      'blood_group': bloodGroup,
      'aadhar_number': aadharNumber,
      'mother_tongue': motherTongue,
      'father_name': fatherName,
      'mother_name': motherName,
      'father_occupation': fatherOccupation,
      'mother_occupation': motherOccupation,
      'phone_number': phoneNumber,
      'phone_number_2': phoneNumber2,
      'email': email,
      'whatsapp_no': whatsappNo,
      'address': address,
      'post_office': postOffice,
      'pincode': pincode,
      'police_station': policeStation,
      'district': district,
      'admission_year_id': admissionYearId,
      'admission_code': admissionCode,
      'ref_no_date': refNoDate?.toIso8601String(),
      'class_id': classId,
      'section_id': sectionId,
      'roll_number': rollNumber,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create from Supabase data
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      dob: map['dob'] != null ? DateTime.parse(map['dob']) : null,
      gender: map['gender'],
      bloodGroup: map['blood_group'],
      aadharNumber: map['aadhar_number'],
      motherTongue: map['mother_tongue'],
      fatherName: map['father_name'],
      motherName: map['mother_name'],
      fatherOccupation: map['father_occupation'],
      motherOccupation: map['mother_occupation'],
      phoneNumber: map['phone_number'],
      phoneNumber2: map['phone_number_2'],
      email: map['email'],
      whatsappNo: map['whatsapp_no'],
      address: map['address'],
      postOffice: map['post_office'],
      pincode: map['pincode'],
      policeStation: map['police_station'],
      district: map['district'],
      admissionYearId: map['admission_year_id'] ?? '',
      admissionCode: map['admission_code'],
      refNoDate: map['ref_no_date'] != null ? DateTime.parse(map['ref_no_date']) : null,
      classId: map['class_id'] ?? '',
      sectionId: map['section_id'],
      rollNumber: map['roll_number'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Copy with method for editing
  Student copyWith({
    String? id,
    String? name,
    DateTime? dob,
    String? gender,
    String? bloodGroup,
    String? aadharNumber,
    String? motherTongue,
    String? fatherName,
    String? motherName,
    String? fatherOccupation,
    String? motherOccupation,
    String? phoneNumber,
    String? phoneNumber2,
    String? email,
    String? whatsappNo,
    String? address,
    String? postOffice,
    String? pincode,
    String? policeStation,
    String? district,
    String? admissionYearId,
    String? admissionCode,
    DateTime? refNoDate,
    String? classId,
    String? sectionId,
    String? rollNumber,
    DateTime? createdAt,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      motherTongue: motherTongue ?? this.motherTongue,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      fatherOccupation: fatherOccupation ?? this.fatherOccupation,
      motherOccupation: motherOccupation ?? this.motherOccupation,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneNumber2: phoneNumber2 ?? this.phoneNumber2,
      email: email ?? this.email,
      whatsappNo: whatsappNo ?? this.whatsappNo,
      address: address ?? this.address,
      postOffice: postOffice ?? this.postOffice,
      pincode: pincode ?? this.pincode,
      policeStation: policeStation ?? this.policeStation,
      district: district ?? this.district,
      admissionYearId: admissionYearId ?? this.admissionYearId,
      admissionCode: admissionCode ?? this.admissionCode,
      refNoDate: refNoDate ?? this.refNoDate,
      classId: classId ?? this.classId,
      sectionId: sectionId ?? this.sectionId,
      rollNumber: rollNumber ?? this.rollNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}