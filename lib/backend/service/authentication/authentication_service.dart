import 'package:crux/backend/repository/user/model/crux_user.dart';

abstract class BaseAuthenticationService {
  Future<CruxUser> signIn();

  Future<CruxUser> signOut();
}
