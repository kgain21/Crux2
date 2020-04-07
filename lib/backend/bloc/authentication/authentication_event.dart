import 'package:crux/backend/blocs/user/models/crux_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class GoogleSignInButtonTapped implements AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AppBarSignOutButtonTapped implements AuthenticationEvent {
  final CruxUser cruxUser;

  const AppBarSignOutButtonTapped({this.cruxUser});

  @override
  List<Object> get props => [cruxUser];
}
