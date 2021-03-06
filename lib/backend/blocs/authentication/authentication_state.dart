import 'package:crux/model/crux_user.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationInProgress extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final CruxUser cruxUser;

  const AuthenticationSuccess({@required this.cruxUser});

  @override
  List<Object> get props => [cruxUser];

  @override
  String toString() => '''AuthenticationSuccess: { firebaseUser: $cruxUser }''';
}

class AuthenticationFailure extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {}
