import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/utils/constant.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_data_source.dart';

class AuthRepositoryImplement implements AuthRepository {
  final AuthDataSource dataSource;
  final NetworkInfo networkInfo;
  final DioClient dioClient;

  AuthRepositoryImplement({
    required this.dataSource,
    required this.networkInfo,
    required this.dioClient,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final result = await dataSource.login(email: email, password: password);
      await _persistSession(result.token, result.user);
      return Right(result.user);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String username,
    required String email,
    required String password,
    required String universityName,
    required String deptName,
    required String batchName,
    required bool isCR,
  }) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final result = await dataSource.register(
        username: username,
        email: email,
        password: password,
        universityName: universityName,
        deptName: deptName,
        batchName: batchName,
        isCR: isCR,
      );
      await _persistSession(result.token, result.user);
      return Right(result.user);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    dioClient.clearAuthToken();
    await StorageService.delete(Constants.keyAuthToken);
    await StorageService.delete(Constants.keyUserId);
    await StorageService.delete(Constants.keyUserRole);
    return const Right(null);
  }

  @override
  Future<bool> isLoggedIn() async {
    return StorageService.containsKey(Constants.keyAuthToken);
  }

  Future<void> _persistSession(String token, UserEntity user) async {
    await StorageService.set(Constants.keyAuthToken, token);
    await StorageService.set(Constants.keyUserId, user.id);
    await StorageService.set(Constants.keyUserRole, user.role);
    dioClient.setAuthToken(token);
  }

  Failure _mapExceptionToFailure(AppException e) {
    if (e is ServerException) return ServerFailure(e.message);
    if (e is NetworkException) return NetworkFailure(e.message);
    if (e is TimeoutException) return ServerFailure(e.message);
    if (e is AuthException) return AuthFailure(e.message);
    return UnknownFailure(e.message);
  }
}