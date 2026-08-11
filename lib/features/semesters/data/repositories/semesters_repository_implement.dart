import 'package:cr_app/features/semesters/domain/entities/resource_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/semesters_entity.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/repositories/semesters_repository.dart';
import '../data_sources/semesters_data_source.dart';

class SemestersRepositoryImplement implements SemestersRepository {
  final SemestersDataSource dataSource;
  final NetworkInfo networkInfo;

  SemestersRepositoryImplement({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SemestersEntity>>> getSemesters() async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final semesters = await dataSource.getSemesters();
      return Right(semesters);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<SubjectEntity>>> getSubjects(int semesterId) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final subjects = await dataSource.getSubjects(semesterId);
      return Right(subjects);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SubjectEntity>> addSubject(int semesterId, String name) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final subject = await dataSource.addSubject(semesterId, name);
      return Right(subject);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> uploadResource(int subjectId, String title, String fileUrl) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await dataSource.uploadResource(subjectId, title: title, fileUrl: fileUrl);
      return const Right(null);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ResourceEntity>>> getResources(int subjectId) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final resources = await dataSource.getResources(subjectId);
      return Right(resources);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(AppException e) {
    if (e is ServerException) return ServerFailure(e.message);
    if (e is NetworkException) return NetworkFailure(e.message);
    return UnknownFailure(e.message);
  }
}
