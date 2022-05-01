import 'package:iba/data/models/user_model.dart';
import 'package:iba/data/network/network_utils.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthRepository {
  Future<User> signIn(String email, String password, bool isRemember) async {
    try {
      final response = await NetworkUtil().getRequest(
        api: '/user/$email/$password',
      );

      final userList = List<User>.from(
        response['items'].map((x) => User.fromJson(x)),
      );
      if (userList.isNotEmpty) {
        if (isRemember) {
          await setValue('islogin', true);
        }
        return userList.first;
      } else {
        throw 'Username or password is incorrect';
      }
    } catch (e) {
      rethrow;
    }
  }
}
