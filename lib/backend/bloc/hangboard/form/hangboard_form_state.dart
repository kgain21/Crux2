import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class HangboardFormState extends Equatable {
  const HangboardFormState();

  @override
  List<Object> get props => [];
}

class HangboardFormUninitialized extends HangboardFormState {

}