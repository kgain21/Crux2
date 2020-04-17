import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class GoogleSignInButtonTapped extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AppBarSignOutButtonTapped extends AuthenticationEvent {
  final CruxUser cruxUser;

  const AppBarSignOutButtonTapped({this.cruxUser});

  @override
  List<Object> get props => [cruxUser];
}
