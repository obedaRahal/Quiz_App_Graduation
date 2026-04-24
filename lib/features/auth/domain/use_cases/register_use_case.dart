import 'package:quiz_app_grad/features/auth/domain/entities/register_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository authRepo;

  RegisterUseCase(this.authRepo);

  Future<RegisterResponseEntity> call({
    required String name,
    required String email,
    required String password,
    required String gender,
  }) {
    return authRepo.register(
      name: name,
      email: email,
      password: password,
      gender: gender,
    );
  }
}