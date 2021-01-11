import 'package:crux/backend/repository/user/model/crux_user.dart';

abstract class BaseUserRepository {

  CruxUser createUser(String displayName, String email);

  CruxUser findUserById(String uid);

  CruxUser updateUser(String uid);

  void deleteUser(String uid);

}