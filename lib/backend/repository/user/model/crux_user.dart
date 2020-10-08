import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class CruxUser extends Equatable {
  final String uid;
  final String displayName;
  final String email;

  const CruxUser({@required this.uid, @required this.displayName, @required this.email});

  @override
  List<Object> get props => [uid, displayName, email];

  @override
  String toString() {
    return '''CruxUser: { uid: $uid, displayName: $displayName, email: $email }''';
  }
}
