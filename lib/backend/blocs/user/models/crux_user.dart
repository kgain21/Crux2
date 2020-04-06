import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class CruxUser extends Equatable {

  final String displayName;
  final String email;

  const CruxUser({@required this.displayName, @required this.email});

  @override
  List<Object> get props => [displayName, email];


}