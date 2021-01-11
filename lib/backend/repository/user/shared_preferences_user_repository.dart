import 'package:crux/backend/repository/user/base_user_repository.dart';
import 'package:crux/backend/repository/user/model/crux_user.dart';

class SharedPreferencesUserRepository extends BaseUserRepository {
  @override
  CruxUser createUser(String displayName, String email) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  void deleteUser(String uid) {
    // TODO: implement deleteUser
  }

  @override
  CruxUser findUserById(String uid) {
    // TODO: implement findUserById
    throw UnimplementedError();
  }

  @override
  CruxUser updateUser(String uid) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

}