import 'package:cr_app/features/semesters/domain/entities/resource_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/semesters_entity.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/repositories/semesters_repository.dart';

class SemestersUseCase {
  final SemestersRepository repository;
  SemestersUseCase({required this.repository});

  Future<Either<Failure, List<SemestersEntity>>> getSemesters() {
    return repository.getSemesters();
  }

  Future<Either<Failure, List<SubjectEntity>>> getSubjects(int semesterId) {
    return repository.getSubjects(semesterId);
  }

  Future<Either<Failure, SubjectEntity>> addSubject(int semesterId, String name) {
    return repository.addSubject(semesterId, name);
  }

  Future<Either<Failure, List<ResourceEntity>>> getResources(int subjectId) {
    return repository.getResources(subjectId);
  }

  Future<Either<Failure, void>> uploadResource(int subjectId, String title, String fileUrl) {
    return repository.uploadResource(subjectId, title, fileUrl);
  }
}
