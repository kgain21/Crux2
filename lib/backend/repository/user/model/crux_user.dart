import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

@immutable
class CruxUser extends Equatable {
  final String uid;
  final String displayName;
  final String email;

  const CruxUser({
    this.uid,
    this.displayName,
    this.email,
  });

  @override
  List<Object> get props => [uid, displayName, email];

  @override
  String toString() {
    return '''CruxUser: { uid: $uid, displayName: $displayName, email: $email }''';
  }
}
