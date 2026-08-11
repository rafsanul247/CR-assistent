import '../../domain/entities/semesters_entity.dart';

class SemestersModel extends SemestersEntity {
  const SemestersModel({
    required super.id,
    required super.name,
    super.subjectCount,
  });

  factory SemestersModel.fromJson(Map<String, dynamic> json) {
    return SemestersModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      subjectCount: json['subjectCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subjectCount': subjectCount,
    };
  }
}
