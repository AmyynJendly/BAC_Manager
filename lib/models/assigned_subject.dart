import 'package:hive/hive.dart';

part 'assigned_subject.g.dart';

@HiveType(typeId: 2)
class AssignedSubject {
  @HiveField(0)
  final String subjectId;

  @HiveField(1)
  final double? customPrice;

  AssignedSubject({required this.subjectId, this.customPrice});

  AssignedSubject copyWith({double? customPrice}) {
    return AssignedSubject(
      subjectId: subjectId,
      customPrice: customPrice ?? this.customPrice,
    );
  }
}
