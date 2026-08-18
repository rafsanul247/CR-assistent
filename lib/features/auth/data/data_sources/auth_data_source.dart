import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/api_endpoint.dart';
import '../models/auth_model.dart';

// Carries both user + token out of the data source together
class AuthResult {
  final UserModel user;
  final String token;

  AuthResult({required this.user, required this.token});
}

abstract class AuthDataSource {
  Future<AuthResult> login({required String email, required String password});
  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
    required String universityName,
    required String deptName,
    required String batchName,
    required bool isCR,
  });
}

class AuthDataSourceImplement implements AuthDataSource {
  final DioClient dioClient;

  AuthDataSourceImplement({required this.dioClient});

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoint.login,
        data: {'email': email, 'password': password},
      );
      return AuthResult(
        user: UserModel.fromJson(response.data['user']),
        token: response.data['token'] as String,
      );
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
    required String universityName,
    required String deptName,
    required String batchName,
    required bool isCR,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoint.register,
        data: {
          'username': username,
          'email': email,
          'password': password,
          'universityName': universityName,
          'deptName': deptName,
          'batchName': batchName,
          'isCR': isCR,
        },
      );
      return AuthResult(
        user: UserModel.fromJson(response.data['user']),
        token: response.data['token'] as String,
      );
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}