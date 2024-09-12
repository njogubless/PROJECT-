import 'package:devotion/features/auth/Repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AuthControllerProvder = Provider(
(ref)=> AuthController(authRepository: ref.read(AuthRepositoryProvider),
),
);

class AuthController {
  final AuthRepository _authRepository;
  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;
}
