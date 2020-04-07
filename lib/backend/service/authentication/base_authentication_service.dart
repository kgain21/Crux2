import 'package:crux/backend/blocs/user/models/crux_user.dart';

abstract class BaseAuthenticationService {
  Future<CruxUser> signIn();

  Future<CruxUser> signOut();
}
