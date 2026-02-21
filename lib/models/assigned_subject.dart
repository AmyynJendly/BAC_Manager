class AssignedSubject {
  final String id;
  final String subjectId;
  final double? customPrice;

  AssignedSubject({
    required this.id,
    required this.subjectId,
    this.customPrice,
  });

  factory AssignedSubject.fromMap(Map<String, dynamic> map) => AssignedSubject(
    id: map['id'],
    subjectId: map['subject_id'],
    customPrice: map['custom_price'] != null
        ? (map['custom_price'] as num).toDouble()
        : null,
  );

  Map<String, dynamic> toMap(String studentId) => {
    'id': id,
    'student_id': studentId,
    'subject_id': subjectId,
    'custom_price': customPrice,
  };

  AssignedSubject copyWith({String? subjectId, double? customPrice}) {
    return AssignedSubject(
      id: id,
      subjectId: subjectId ?? this.subjectId,
      customPrice: customPrice ?? this.customPrice,
    );
  }
}
