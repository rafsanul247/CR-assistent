import '../../domain/entities/subject_entity.dart';

class SubjectModel extends SubjectEntity {
  const SubjectModel({
    required super.id,
    required super.name,
    super.resourceCount,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      resourceCount: json['resourceCount'] as int? ?? 0,
    );
  }
}
