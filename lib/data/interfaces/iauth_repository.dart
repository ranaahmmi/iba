import 'package:iba/data/models/user_model.dart';

abstract class IAuthRepository {
  Future<User> signIn(String email, String password, bool isRemember);
}
