import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;

  const LoadingIndicator({this.color});

  @override
  Widget build(context) => Center(
        child: CircularProgressIndicator(backgroundColor: color,),
      );
}
