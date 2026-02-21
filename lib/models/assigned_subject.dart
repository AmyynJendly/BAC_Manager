import 'package:hive/hive.dart';

part 'assigned_subject.g.dart';

@HiveType(typeId: 2)
class AssignedSubject extends HiveObject {
  @HiveField(0)
  String subjectId;

  @HiveField(1)
  double? customPrice;

  AssignedSubject({required this.subjectId, this.customPrice});

  AssignedSubject copyWith({double? customPrice}) {
    return AssignedSubject(
      subjectId: subjectId,
      customPrice: customPrice ?? this.customPrice,
    );
  }
}
